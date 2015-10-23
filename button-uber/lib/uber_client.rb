require 'uber'

module RequestPriceEstimates
  class PriceEstimate < Uber::Base
    attr_accessor :surge_multiplier, :minimum, :surge_confirmation_id

    def initialize(obj)
      if obj.is_a?(Hash)
        super
      end
    end
  end

  def request_price_estimations(*args)
    arguments = Uber::Arguments.new(args)
    o = perform_with_objects(:post, "/v1/requests/estimate", arguments.options, PriceEstimate)
    o.detect { |k| k.surge_multiplier }
  end
end

Uber::Client.class_eval do
  include RequestPriceEstimates
end

class UberClient

  def self.trip_details(bearer_token, trip_id)
    client(bearer_token).trip_details(trip_id)
  end

  def self.request_to(bearer_token, prod_id, start_loc, end_loc, surge_confirmation)
    hash = loc_hash_for(prod_id, start_loc, end_loc)
    if surge_confirmation
      hash[:surge_confirmation_id] = surge_confirmation
    end

    client(bearer_token).trip_request hash
  end

  def self.price_to(bearer_token, prod_id, start_loc, end_loc = nil)
    client(bearer_token).request_price_estimations(loc_hash_for(prod_id, start_loc, end_loc))
  end

  def self.time_from(bearer_token, location)
    client(bearer_token).time_estimations(start_latitude: location[:latitude], start_longitude: location[:longitude])
  end

  def self.client(bearer_token)
    Uber::Client.new do |config|
      config.server_token  = ENV["UBER_SERVER_TOKEN"]
      config.client_id     = ENV["UBER_CLIENT_ID"]
      config.client_secret = ENV["UBER_CLIENT_SECRET"]
      config.bearer_token  = bearer_token
    end
  end

  def self.loc_hash_for(prod_id, start_loc, end_loc = nil)
    base = {product_id: prod_id, start_latitude: start_loc[:latitude], start_longitude: start_loc[:longitude]}
    if end_loc
      base[:end_latitude] = end_loc[:latitude]
      base[:end_longitude] = end_loc[:longitude]
    end
    base
  end

end