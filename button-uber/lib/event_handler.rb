require 'json'
require 'aws-sdk'

class EventHandler

  def initialize
    @client = MqttClient.new
    @client.subscribe 'button1_presses'
    @uber_token = Tokens.token_for :callumj
    @home = Locations.location_for :home
    @sns = Aws::SNS::Client.new(region: 'us-east-1')

    # this blocks
    @client.handle do |topic, message|
      handle_message topic, message
    end
  end

  def handle_message(topic, message)
    return unless topic == 'button1_presses'
    json = JSON.parse message
    return unless json["clickType"] == "DOUBLE"
    pricing = UberClient.price_to @uber_token, ENV['UBER_PRODUCT_ID'], @home
    surge_confirmation = nil
    if pricing.surge_multiplier > 1.0 && pricing.surge_multiplier <= 1.2
      surge_confirmation = pricing.surge_confirmation_id
    elsif pricing.surge_multiplier > 1.2
      send_sms "Will not call Uber, surge is #{pricing.surge_multiplier}"
      return
    end
    c = UberClient.request_to @uber_token, ENV['UBER_PRODUCT_ID'], @home, nil, surge_confirmation
    send_sms "Uber called, status is #{c.status}."
    STDERR.puts c.inspect

    if c.eta
      notify_eta c.eta
      return
    end

    sleep 10

    count = 0
    trip = nil
    while count <= 30 && (trip = UberClient.trip_details(@uber_token, c.request_id)) && trip.status == 'processing' do
      count += 1
      sleep 1
    end

    if trip.eta
      notify_eta trip.eta
      return
    end

    send_sms "ETA could not be established, please check the app."
  rescue StandardError => err
    STDERR.puts err.inspect
    send_sms "Application error: #{err.inspect}"
  end

  def notify_eta(eta)
    send_sms "Uber is #{eta}m away"
  end

  def send_sms(message)
    @sns.publish({topic_arn: ENV['AWS_SNS_TOPIC'], message: message})
  end

  def disconnect
    @client.disconnect
  end

end