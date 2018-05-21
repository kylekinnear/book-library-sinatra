require '.config/environment'

class BooksController < ApplicationController

  get '/my-library/new'
    if logged_in?
      erb :'books/create_book'
    else
      redirect to '/login'
    end
  end
