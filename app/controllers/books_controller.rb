require '.config/environment'

class BooksController < ApplicationController

  get '/my-library/new'
    if logged_in?
      erb :'books/create_book'
    else
      redirect to '/'
    end
  end

  #we still need to add tags to the following:
  post '/my-library' do
    if logged_in?
      if params[:title] != "" && params[:author] != ""
        @book = current_user.books.new(title: params[:title], author: params[:author]) #is this correct?
        if params[:read_it] == 1
          @book.read? = 1
          @book.times_read = params[:times_read]
        end
        if params[:own_it] == 1
          @book.owned? = 1
        end
        if @book.location != ""
          @book.location = params[:location]
        end
        if params[:comments] != ""
          @book.comments = params[:comments]
        end
        if params[:get_goodreads?] == 1
          #scrape
        end
        @book.save
      else
        redirect to '/my-library/new'
      end
      redirect to '/'
    end
  end




end
