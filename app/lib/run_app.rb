# Load Paths
lib_path = File.expand_path('../', __FILE__)
($:.unshift lib_path) unless ($:.include? lib_path)

require 'sinatra'
require 'dbclient'
require 'json'
# Listen on all interfaces in the development environment
set :bind, '0.0.0.0'

before do
  content_type :html
end

get '/' do
  erb :index
end

get '/show/minions' do
  client = DBClient.new
  @minions = client.show_all

  erb :all
end

post '/insert' do
  @name = params[:minion]
  client = DBClient.new
  client.insert(@name)

  erb :insert
end

post '/delete' do
  id = params[:id]
  client = DBClient.new
  client.delete(id)
  erb :index
end