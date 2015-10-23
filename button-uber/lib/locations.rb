require 'json'

class Locations

  def self.location_for(name = :home)
    path = File.dirname(__FILE__) + "/../data/locations/#{name}.json"
    contents = File.read(path)
    x = JSON.parse(contents)
    {latitude: x[0], longitude: x[1]}
  end

end