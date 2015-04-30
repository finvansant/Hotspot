require_relative './config/environment'

namespace :db do
  desc "migrate the db"
  task :migrate do
    connection_details = YAML::load(File.open('./config/database.yml'))
    ActiveRecord::Base.establish_connection(connection_details)
    ActiveRecord::Migrator.migrate("./db/migrate/")
  end

  desc "seed the db"
  task :seed do
    require_relative "./db/seeds.rb"
  end

  desc "drop and recreate the db"
  task :reset => [:drop, :migrate, :seed]

  desc "drop the db"
  task :drop do
    connection_details = YAML::load(File.open('config/database.yml'))
    File.delete(connection_details.fetch('database')) if File.exist?(connection_details.fetch('database'))
  end
end

namespace :pop do
  desc "Populate the users table"
  task :users do
    Populate.users
  end

  desc "Populate posts for every user"
  task :posts do
    Populate.posts
  end
end

namespace :create do
  desc "Create locations from post database"
  task :locations do
    Analyze.locations
  end
end

namespace :categories do
  desc "Populates categories"
  task :populate do
    Category.create
  end
end