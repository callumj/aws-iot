require 'sinatra'
require 'lib/web/oauth_flow'

module Web
  class Server < Sinatra::Application
    configure do
      disable :method_override

      set :root, File.dirname(__FILE__)
      set :server, :puma
      set :port, 3000
      set :bind, '0.0.0.0'
    end

    use Rack::Deflater
    use Web::OauthFlow
  end
end