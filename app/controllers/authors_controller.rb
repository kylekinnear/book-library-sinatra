require './config/environment'

class AuthorsController < ApplicationController

  get '/authors/:id' do
    if logged_in?
      @author = Author.find_by_id(params[:id])
      if @author
        erb :'author/show_author'
      else
        redirect to '/my-library'
      end
    else
      redirect to '/'
    end
  end

end
