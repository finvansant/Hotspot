NEARBY_SEARCH_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"

def nearby_search(lat, lng, name)
  options = {location_component: "location=#{lat},#{lng}",
             name_component: "name=#{name}",...}
  search = NEARBY_SEARCH_URL + prepare(options)
  HTTParty::get(search)["results"].first
end