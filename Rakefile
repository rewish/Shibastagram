require 'rubygems'
require File.dirname(__FILE__) + '/lib/boot'

namespace :db do
  desc "migrate database"
  task :migrate do
    ActiveRecord::Migrator.migrate('db/migrate',
          ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
  end
end

namespace :hh do
  desc "update photos"
  task :update do
    Photo.fetch_and_update
  end

  desc "make token"
  task :token do
    puts "----------------------------------------"
    puts Digest::SHA1.hexdigest(Time.now.to_s)
    puts "----------------------------------------"
  end
end
