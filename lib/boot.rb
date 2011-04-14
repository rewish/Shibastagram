require 'rubygems'
require 'instagram'
require 'json'
require 'active_record'
require 'active_support'

# Extended: Instagram.Client.Tags
require "#{File.dirname(__FILE__)}/tags"

# Environment
require "#{File.dirname(__FILE__)}/../config/environment"

# Database config
begin
  File.open("#{File.dirname(__FILE__)}/../config/database.yml", 'r') do |content|
    dbconf = YAML::load(content)
    ActiveRecord::Base.establish_connection dbconf['production']
  end
rescue => e
  puts e.message
end

# Autoload
Dir::glob("#{File.dirname(__FILE__)}/../models/*.rb") do |file|
  load file
end
