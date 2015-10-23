require 'mqtt'

class MqttClient

  attr_reader :client

  def initialize
    @client = MQTT::Client.new
    client.host = ENV['MQTT_HOST']
    client.port = (ENV['MQTT_PORT'] || 8883).to_i
    client.ssl = true
    client.cert_file = File.expand_path(File.dirname(__FILE__) + "/../data/certs/cert.crt")
    client.key_file  = File.expand_path(File.dirname(__FILE__) + "/../data/certs/client.key")
    client.ca_file   = File.expand_path(File.dirname(__FILE__) + "/../data/certs/ca.pem")
    client.connect()
    client
  end

  def handle
    raise "Block required" unless block_given?
    client.get do |topic,message|
      yield topic, message
    end
  end

  def subscribe(topic)
    client.subscribe topic
  end

  def disconnect
    client.disconnect
  end

end