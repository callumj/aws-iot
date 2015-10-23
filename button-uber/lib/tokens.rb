require 'json'

class Tokens

  def self.token_for(name = :callumj)
    path = File.dirname(__FILE__) + "/../data/tokens/#{name}.json"
    contents = File.read(path)
    JSON.parse(contents)['access_token']
  end

end