require 'google_places'  
client = GooglePlaces::Client.new("sdaDF23sdf3fjjk322sSfkjl23sd")  
client.spots(40.705329, -74.01397, :name => 'Flatiron School')

# => [<GooglePlaces::Spot:0x007ff4d11a7138,... @url=nil,@website=nil]