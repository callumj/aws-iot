require 'bundler/setup'

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'lib/web'
require 'lib/uber_client'
require 'lib/tokens'
require 'lib/locations'
require 'lib/mqtt_client'