require './config/environment'

class ApplicationController < Sinatra::Base

  configure do

  end

  get '/' do
    erb :index
  end

  helpers do

  end

end
