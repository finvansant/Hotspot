class Location < ActiveRecord::Base

  belongs_to :user
  belongs_to :cat
  has_and_belongs_to_many :posts

  @@dist_threshold = 200
  @@word_pct_threshold = 0.7
  @@google_client = GooglePlacesAPI.new

  def self.filter_stopwords(array)
    array.delete_if {|word|
      STOP_WORDS.member?(word.downcase)
    }
  end

  def self.create_for_user(user)
    # Destroy previous locations
    destroy_all(:user_id => user.id)

    # Find posts relevant to user
    followed_user_ids = user.followed_users.map {|u| u.id}
    relevant_posts = Post.all.select {|post| followed_user_ids.include? post.user_id}

    # For each of these
    relevant_posts.each {|post|
      # Search all other posts
      matches = relevant_posts.select {|check_post|
        match = false
        if post != check_post && post.user_id != check_post.user_id
          if distance([post.lat, post.lng],[check_post.lat, check_post.lng]) < @@dist_threshold
            if post_location_sig_words = filter_stopwords(post.location_name.split(" "))
              text_match_threshold = [1,(post_location_sig_words.size * @@word_pct_threshold).to_i].max
              count = 0
              post_location_sig_words.each {|word|
                count += 1 if check_post.location_name.downcase.split(/[,.;]*[ ]/).include? word.downcase
              }
              match = true if count >= text_match_threshold
            end
          end
        end
        match
      }
      # If result is returned,
      if matches.size > 0
        # Create new location
        l = Location.new
        l.name = post.location_name
        l.lat = post.lat
        l.lng = post.lng
        l.user_id = user.id
        l.url = l.get_url
        l.posts << post
        matches.each {|p| l.posts << p}
        l.save
        # Delete matches
        relevant_posts.delete_if {|p| matches.include? p}
      else
        l = Location.new
        l.name = post.location_name
        l.lat = post.lat
        l.lng = post.lng
        l.user_id = user.id
        l.url = l.get_url
        l.posts << post
        l.save
      end
    }

    # Calculate count
    Location.where(:user_id => user.id).each {|location|
      location.count = location.posts.map{|p| p.user_id}.uniq.size
      location.save
    }
  end

  def self.create_for_category(category)
    # Destroy previous locations
    destroy_all(:cat_id => category.id)

    # Find posts relevant to category
    user_ids = category.users.map {|u| u.id}
    relevant_posts = Post.all.select {|post| user_ids.include? post.user_id}

    # For each of these
    relevant_posts.each {|post|
      # Search all other posts
      matches = relevant_posts.select {|check_post|
        match = false
        if post != check_post
          if distance([post.lat, post.lng],[check_post.lat, check_post.lng]) < @@dist_threshold
            if post_location_sig_words = filter_stopwords(post.location_name.split(" "))
              text_match_threshold = [1,(post_location_sig_words.size * @@word_pct_threshold).to_i].max
              count = 0
              post_location_sig_words.each {|word|
                count += 1 if check_post.location_name.downcase.split(/[,.;]*[ ]/).include? word.downcase
              }
              match = true if count >= text_match_threshold
            end
          end
        end
        match
      }
      # If result is returned,
      if matches.size > 0
        # Create new location
        l = Location.new
        l.name = post.location_name
        l.lat = post.lat
        l.lng = post.lng
        l.cat_id = category.id
        l.url = l.get_url
        l.posts << post
        matches.each {|p| l.posts << p}
        l.save
        # Delete matches - do not delete current post because that will fuck up "each" and won't speed anything
        relevant_posts.delete_if {|p| matches.include? p}
      else
        l = Location.new
        l.name = post.location_name
        l.lat = post.lat
        l.lng = post.lng
        l.cat_id = category.id
        l.url = l.get_url
        l.posts << post
        l.save
      end
    }
    # Calculate count
    Location.where(:cat_id => category.id).each {|location|
      location.count = location.posts.map{|p| p.user_id}.uniq.size
      location.save
    }
  end

  def self.list(locations)
    output = []
    locations = locations.sort_by{|x|x.count}.reverse
    locations.each_with_index {|location, index|
      row = "[\'<div class=\"info-window\">"
      row << "<div class=\"loc-name\">#{location.clean_name}</div>"
      row << "<div class=\"loc-url\"><a href=\"#{location.url}\">#{location.url.gsub(/http[s]*:\/\//,"")}</a></div>" if location.url
      row << "</div>"
      location.posts.each {|post|
        name = post.user.name
        name = post.user.instagram_username if (name == "" or !name)
        row << "<div class=\"post-wrap\">"
        row << "<div class=\"post-pic\"><img src=\"#{post.content_url}\" ></div>"
        row << "<div class=\"user\">#{name}</div>"
        row << "<div class=\"post-caption\">#{post.clean_text}</div>"
        row << "</div>"
      }
      row << "</div>\', #{location.lat.round(6)}, #{location.lng.round(6)}, #{location.count}"
      row << "]"
      output << row
      }
    "[" + output.join(",") + "]"
  end

  def get_url
    begin
      if google_url = @@google_client.get_url(lat, lng, name)
        google_url
      elsif (wiki = Wikipedia.find(name, :prop => "info")) && (wiki.page["pageid"] != -1)
        wiki.fullurl
      end
    rescue
      puts "#{name} had URL Error"
    end
  end

  def clean_name
    HTMLEntities.new.encode(name).delete("\n") if name
  end

  STOP_WORDS = [
    'a','cannot','into','our','thus','about','co','is','ours','to','above',
    'could','it','ourselves','together','across','down','its','out','too',
    'after','during','itself','over','toward','afterwards','each','last','own',
    'towards','again','eg','latter','per','under','against','either','latterly',
    'perhaps','until','all','else','least','rather','up','almost','elsewhere',
    'less','same','upon','alone','enough','ltd','seem','us','along','etc',
    'many','seemed','very','already','even','may','seeming','via','also','ever',
    'me','seems','was','although','every','meanwhile','several','we','always',
    'everyone','might','she','well','among','everything','more','should','were',
    'amongst','everywhere','moreover','since','what','an','except','most','so',
    'whatever','and','few','mostly','some','when','another','first','much',
    'somehow','whence','any','for','must','someone','whenever','anyhow',
    'former','my','something','where','anyone','formerly','myself','sometime',
    'whereafter','anything','from','namely','sometimes','whereas','anywhere',
    'further','neither','somewhere','whereby','are','had','never','still',
    'wherein','around','has','nevertheless','such','whereupon','as','have',
    'next','than','wherever','at','he','no','that','whether','be','hence',
    'nobody','the','whither','became','her','none','their','which','because',
    'here','noone','them','while','become','hereafter','nor','themselves','who',
    'becomes','hereby','not','then','whoever','becoming','herein','nothing',
    'thence','whole','been','hereupon','now','there','whom','before','hers',
    'nowhere','thereafter','whose','beforehand','herself','of','thereby','why',
    'behind','him','off','therefore','will','being','himself','often','therein',
    'with','below','his','on','thereupon','within','beside','how','once',
    'these','without','besides','however','one','they','would','between','i',
    'only','this','yet','beyond','ie','onto','those','you','both','if','or',
    'though','your','but','in','other','through','yours','by','inc','others',
    'throughout','yourself','can','indeed','otherwise','thru','yourselves']

end