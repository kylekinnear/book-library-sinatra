require './config/environment'

class BooksController < ApplicationController

  get '/my-library/new' do
    if logged_in?
      erb :'books/create_book'
    else
      flash[:message] = "Please log in."
      redirect to '/'
    end
  end

  post '/my-library' do
    if logged_in?
      if params[:title] != "" && params[:author] != ""
        @book = current_user.books.new(title: params[:title])
        @slug = params[:author].downcase.gsub(".","").gsub(" ","-")
        @book.author = Author.match_author(@slug, params[:author])
        if @book.location != ""
          @book.location = params[:location]
        end
        if params[:comments] != ""
          @book.comments = params[:comments]
        end
        @book.save
        flash[:message] = "Added new book!"
        redirect to '/my-library'
      else
        flash[:message] = "Couldn't create the book. Make sure you have a title and an author."
        redirect to '/my-library/new'
      end
      flash[:message] = "Please log in."
      redirect to '/my-library'
    end
  end

  get '/my-library/:id' do
    if logged_in?
      @book = Book.find_by_id(params[:id])
      if @book && @book.user == current_user
        erb :'books/show_book'
      else
        flash[:message] = "You don't have access to that book."
        redirect to '/my-library'
      end
    else
      flash[:message] = "Please log in."
      redirect to '/'
    end
  end

  post '/my-library/:id' do
    if logged_in?
      @book = Book.find_by_id(params[:id])
      if @book && @book.user == current_user
        erb :'books/show_book'
      else
        redirect to '/my-library'
      end
    else
      flash[:message] = "Please log in."
      redirect to '/'
    end
  end

  patch '/my-library/:id' do
    if logged_in?
      if params[:title] != "" && params[:author] != ""
        @book = Book.find_by_id(params[:id])
        if @book && @book.user == current_user
          @book.update(title: params[:title])
          @slug = params[:author].downcase.gsub(".","").gsub(" ","-")
          @book.update(author: Author.match_author(@slug, params[:author]))
          if params[:location] != ""
            @book.update(location: params[:location])
          end
          if params[:comments] != ""
            @book.update(comments: params[:comments])
          end
          flash[:message] = "Updated book."
          redirect to "/my-library/#{@book.id}"
        else
          flash[:message] = "You don't have access to that book."
          redirect to '/my-library/'
        end
      else
        flash[:message] = "Please enter a title and an author."
        redirect to "/my-library/#{@book.id}/edit"
      end
    else
      flash[:message] = "Please log in."
      redirect to '/'
    end
  end

  get '/my-library/:id/edit' do
    if logged_in?
      @book = Book.find_by_id(params[:id])
      if @book && @book.user == current_user
        erb :'books/edit_book'
      else
        flash[:message] = "You don't have access to that book."
        redirect to '/my-library'
      end
    else
      flash[:message] = "Please log in."
      redirect to '/'
    end
  end

  delete '/my-library/:id/delete' do
    if logged_in?
      @book = Book.find_by_id(params[:id])
      if @book && @book.user == current_user
        @book.delete
      end
      flash[:message] = "Book deleted."
      redirect to '/my-library'
    else
      flash[:message] = "You don't have access to that book."
      redirect to '/'
    end
  end

end
