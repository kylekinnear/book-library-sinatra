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
  #this also needs to instantiate authors and tags that do not already exist
  post '/my-library' do
    if logged_in?
      if params[:title] != "" && params[:author] != ""
        @book = current_user.books.new(title: params[:title], author: params[:author]) #is this correct?
#        @book.author_id = Author.find_by_slug(@book.author.downcase.gsub(".","").gsub(" ","-")).id #this builds a loose association between book, author_id while saving name?
        #@book.user_id = session[:user_id] - do we need this?
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
          @book.goodreads_flag = 1
          #scrape
        end
        @book.save
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

  post '/my-library/:id/edit' do
    if logged_in?
      @book = Book.find_by_params(params[:id]) #is this going to work or is it going to try and look at the posted data?
      if @book && @book.user_id == current_user.id
        erb :'books/edit_book'
      else
        redirect to '/my-library'
      end
    else
      redirect to '/'
    end
  end

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
