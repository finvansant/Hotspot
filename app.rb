class App < Sinatra::Base
  set :session_secret, "enter here"
  enable :sessions

  CALLBACK_URL = "http://localhost:9393/auth/instagram/callback"

  Instagram.configure do |config|
    config.client_id = "enter here"
    config.client_secret = "enter here"
  end

  get "/" do
    session[:category] = nil
    erb :splash
  end

  get "/main" do
    erb :load
  end

  get "/main/:category" do
    session[:category] = params[:category] if params[:category]
    redirect "/main"
  end

  get "/auth/instagram/connect" do
    redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
  end

  get "/auth/instagram/callback" do
    response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
    session[:access_token] = response.access_token
    redirect "/main"
  end

  get "/map" do
    if session[:category]
      category = Cat.find_by(:name => session[:category])
      @locations = category.locations
    else
      # Create Instagram client
      client = Instagram.client(:access_token => session[:access_token])

      # Populate/update DB using client
      user = User.get_user(client)

      # Add/update users followed by client and their recent posts
      user.update_followed_users

      # Perform location analysis on posts of client's followed users
      user.create_locations

      @locations = user.locations
    end
    # Create map
    erb :map
  end

end