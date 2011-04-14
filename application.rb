require File.dirname(__FILE__) + '/lib/boot'
require 'sinatra'

get '/' do
  erb :index
end

get '/api/photos.json' do
  limit  = (params[:count] || 30).to_i
  limit  = limit > 150 ? 150 : limit
  page   = (params[:page] || 1).to_i
  offset = (page - 1) * limit
  max_page  = (Photo.count / limit).ceil
  next_page = max_page > page ? page + 1 : nil

  photos = Photo.find(:all, {
    :limit => limit,
    :offset => offset,
    :order => 'created_time DESC'
  })

  ActiveRecord::Base.include_root_in_json = false
  content_type :json
  {:data => photos, :next => next_page}.to_json
end

get '/api/make_token' do
  Digest::SHA1.hexdigest(Time.now.to_s)
end

get '/tasks/update' do
  return unless params[:token] == CRON_TOKEN
  Photo.fetch_and_update
  return
end

