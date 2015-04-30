require 'slide_hero'

presentation 'hs_pres' do
  slide "", background: 'slide1.png' do end
  slide "", background: 'slide2.png' do end
  slide "", background: 'slide3.png' do end
  slide "", background: 'slide4.png' do end
  slide "", background: 'slide5.png' do end
  slide "", background: 'slide6.png' do end
  slide "", background: 'slide7.png' do end
  slide "", background: 'slide8.png' do end

  slide "Google Places Ruby gem" do
    code :ruby do
      "google_places_gem.rb"
    end
  end

  slide "But Google Maps has it!" do
    image "Flatiron Google Maps Query.png"
  end

  slide "Getting Google Places API results directly" do
    code :ruby do
      "google_places_redone.rb"
    end
  end

  slide "It works!" do
    image "Flatiron Found.png"
  end

  slide "Populating data on a map" do
    code :ruby do
      "google_maps.js"
    end
  end

  slide "Use ERB to populate the locations array" do
    code :ruby do
      "erb.js"
    end
  end

  # Parker opens example.html

  slide "", background: 'slide9.png' do end
  slide "", background: 'slide10.png' do end



end
