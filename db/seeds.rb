x = User.new
x.name = "Parker Lawrence"
x.instagram_username = "exxonmobil_us"
x.instagram_id = 1579221533
x.save

# x = User.new
# x.name = "Lawrence Parker"
# x.instagram_username = "us_exxonmobil"
# x.instagram_id = 1229751
# x.last_update = Time.now
# x.save

# x = FollowedUser.new
# x.user_id = 1
# x.followed_user_id = 2
# x.save

# x = Post.new
# x.user_id = 2
# x.save

# x = Location.new
# x.user_id = 1
# x.save

# Post.all.first.locations << Location.all.first

# binding.pry

Cat.create
Cat.all.each {|category| category.update_posts}
Cat.all.each {|category| category.create_locations}