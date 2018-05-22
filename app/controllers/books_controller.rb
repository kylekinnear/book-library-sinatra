require './config/environment'

class BooksController < ApplicationController

  get '/my-library/new' do
    if logged_in?
      erb :'books/create_book'
    else
      redirect to '/'
    end
  end

  post '/my-library' do
    if logged_in?
      if params[:title] != "" && params[:author] != ""
        @book = current_user.books.new(title: params[:title]) #is this correct?
        @slug = params[:author].downcase.gsub(".","").gsub(" ","-")
        @book.author = Author.match_author(@slug, params[:author])
        if params[:read_it] == 1
          @book.read_flag = 1
          @book.times_read = params[:times_read]
        end
        if params[:own_it] == 1
          @book.owned_flag = 1
        end
        if @book.location != ""
          @book.location = params[:location]
        end
        if params[:comments] != ""
          @book.comments = params[:comments]
        end
        if params[:get_goodreads?] == 1
          @book.goodreads_flag = 1
          #scrape
        end
        if params[:tags] != ""
          @book.create_tags(params[:tags])
        end
        @book.save
        redirect to '/my-library'
      else
        redirect to '/my-library/new'
      end
      redirect to '/'
    end
  end

  get '/my-library/:id' do
    if logged_in?
      @book = Book.find_by_id(params[:id])
      if @book && @book.user_id == current_user.id
        erb :'books/show_book'
      else
        redirect to '/my-library'
      end
    else
      redirect to '/'
    end
  end

  post '/my-library/:id' do
    if logged_in?
      @book = Book.find_by_id(params[:id])
      if @book && @book.user_id == current_user.id
        @book.goodreads_flag = 1
        #scrape
        erb :'books/show_book'
      else
        redirect to '/my-library'
      end
    else
      redirect to '/'
    end
  end

  patch '/my-library/:id' do
    if logged_in?
      if params[:title] != "" && params[:author] != ""
        @book = Book.find_by_id(params[:id])
        if @book && @book.user_id == current_user.id
          #this is where we code the actual editing
        end
      end
    end
  end

  get '/my-library/:id/edit' do
    if logged_in?
      @book = Book.find_by_id(params[:id])
      if @book && @book.user_id == current_user.id
        erb :'books/edit_book'
      else
        redirect to '/my-library'
      end
    else
      redirect to '/'
    end
  end

#  post '/my-library/:id/edit' do # commented out using links instead of buttons
#    if logged_in?
#      @book = Book.find_by_params(params[:id]) #is this going to work or is it going to try and look at the posted data?
#      if @book && @book.user_id == current_user.id
#        erb :'books/edit_book'
#      else
#        redirect to '/my-library'
#      end
#    else
#      redirect to '/'
#    end
#  end

  delete '/my-library/:id/delete' do
    if logged_in?
      @book = Book.find_by_id(params[:id])
      if @book && @book.user_id == current_user.id
        @book.delete
      end
      redirect to '/my-library'
    else
      redirect to '/'
    end
  end

end
