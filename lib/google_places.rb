require_relative '../config/environment'

class GooglePlacesAPI
  attr_reader :api_key
  include ::HTTParty

  NEARBY_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
  DETAILS_URL = "https://maps.googleapis.com/maps/api/place/details/json?"
  ENCODER = HTMLEntities.new

  def initialize
    @api_key = "enter here"
  end

  def nearby_search(lat, lng, name)
    options = {
      key_component: "key=#{@api_key}",
      location_component: "location=#{lat},#{lng}",
      name_component: "name=#{ENCODER.encode(name, :named).gsub(/[|]/,"").gsub(/[ ]{2,}/," ")}",
      rank_option: "rankby=distance"
    }

    search = NEARBY_URL + join_options(options)
    
    if (results = self.class.get(search)["results"]) && (results != [])
      results.first["place_id"]
    end
  end

  def get_url(lat, lng, name)
    place_id = nearby_search(lat,lng,name)
    if place_id
      options = {
        place_id_component: "placeid=#{place_id}",
        key_component: "key=#{@api_key}"
      }

      search = DETAILS_URL + join_options(options)

      if result = self.class.get(search)["result"]
        result["website"]
      end
    end
  end

  def join_options(options)
    options.values.join("&")
  end
end