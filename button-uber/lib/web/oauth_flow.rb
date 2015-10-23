require 'sinatra'
require 'faraday'
require 'faraday_middleware'

module Web
  class OauthFlow < Sinatra::Application
    CLIENT_ID = ENV['UBER_CLIENT_ID']
    REDIRECT_URL = ENV['REDIRECT_URL'] || 'http://localhost:3000/auth'
    SECRET = ENV['UBER_CLIENT_SECRET']
    AUTH_URL = 'https://login.uber.com/oauth/authorize'
    TOKEN_URL = 'https://login.uber.com/oauth/token'

    get '/' do
      query_string = Rack::Utils.build_query({
        :client_id => CLIENT_ID,
        :redirect_uri => REDIRECT_URL,
        :response_type => "code"
        })
      redirect "#{AUTH_URL}?#{query_string}"
    end

    get "/auth" do
      query_string = Rack::Utils.build_query({
        :client_secret => SECRET,
        :client_id => CLIENT_ID,
        :grant_type => "authorization_code",
        :redirect_uri => REDIRECT_URL,
        :code => params[:code]
        })
      puts query_string
      puts params[:code]
      response = Faraday.post("#{TOKEN_URL}?#{query_string}")
      "#{response.body}"
    end
  end
end