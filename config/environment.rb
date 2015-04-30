require 'bundler/setup'
Bundler.require(:default, :development)
require 'active_record'
require 'yaml'
require 'csv'
require 'wikipedia'
require 'shotgun'

connection_details = YAML::load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection(connection_details)

# Configure Instagram API
Instagram.configure do |config|
  config.client_id = "enter_here"
  config.client_secret = "enter_here"
end

require_all './lib'
require_all './app/models'
require './app'