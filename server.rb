require 'sinatra'
require 'pg'
require 'pry'
require 'shotgun'

#------------------------------------------ Routes ------------------------------------------

get '/' do

erb :index
end
