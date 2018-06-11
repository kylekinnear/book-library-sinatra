require './config/environment'

class AuthorsController < ApplicationController

  get '/authors/:id' do
    if logged_in?
      @author = Author.find_by_id(params[:id])
      if @author
        erb :'authors/show_author'
      else
        flash[:message] = "You don't have any books by that author."
        redirect to '/my-library'
      end
    else
      flash[:message] = "Please log in."
      redirect to '/'
    end
  end

end
