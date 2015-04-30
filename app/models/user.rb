class User < ActiveRecord::Base

  belongs_to :cat
  has_many :posts
  has_many :locations

  has_many :followed_users_association, :class_name => "FollowedUser"
  has_many :followed_users, :through => :followed_users_association, :source => :followed_user
  has_many :followed_by_users_association, :class_name => "FollowedUser", :foreign_key => :followed_used_id
  has_many :followed_by_users, :through => :followed_by_users_association, :source => :user

  attr_accessor :client
  @@update_time = (48 * 60 * 60) # 48 hours

  def self.get_user(client)
    user = add_or_update(client.user)
    user.client = client
    user
  end

  def self.add_or_update(user, followed_by=nil, category=nil)
    new_user = false
    user_from_db = User.where(instagram_id: user.id.to_i).first_or_create do |u|
      u.instagram_username = user.username
      u.instagram_id = user.id.to_i
      u.name = user.full_name
      new_user = true
    end
    followed_by.link_followed_user(user_from_db, new_user) if followed_by
    user_from_db.cat_id = category.id if category
    user_from_db.save
    user_from_db
  end

  def update_followed_users
    if update_needed?
      client.user_follows.each {|followed_user|
        # Add / update followed user in DB
        followed_user = User.add_or_update(followed_user, self)
        Post.add_to_db(followed_user, client)
      }
    end
  end

  def create_locations
    if update_needed?
      self.last_update = Time.now
      self.save
      Location.create_for_user(self)
    end
  end

  def update_needed?
    last_update == nil || Time.now - last_update > @@update_time
  end

  def link_followed_user(followed_user, new_user)
    if new_user
      FollowedUser.create(:user_id => self.id, :followed_user_id => followed_user.id)
    else
      FollowedUser.where(:user_id => self.id, :followed_user_id => followed_user.id).first_or_create
    end
  end

end