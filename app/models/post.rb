class Post < ActiveRecord::Base

  belongs_to :user
  has_and_belongs_to_many :locations

  # Update followed user's posts in DB
  def self.add_to_db(user, client)
    begin
      posts = client.get("https://api.instagram.com/v1/users/" + user.instagram_id.to_s + "/media/recent")
      posts.each {|post|
        if post["location"] && post["location"]["latitude"] && post["location"]["name"]
          self.where(:user_id => user.id, :instagram_post_id => post["id"]).first_or_create do |p|
            p.content_url = post["images"]["low_resolution"]["url"]
            if post["caption"]
              p.text = post["caption"]["text"]
              p.created_time = post["caption"]["created_time"].to_i
            end
            p.lat = post["location"]["latitude"]
            p.lng = post["location"]["longitude"]
            p.location_name = post["location"]["name"]
          end
        end
      }
    rescue
      puts "#{user.instagram_username} is private user"
    end
  end

  def clean_text
    HTMLEntities.new.encode(text).delete("\n") if text
  end

end