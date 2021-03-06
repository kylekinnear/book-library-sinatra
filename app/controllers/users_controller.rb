require './config/environment'

class UsersController < ApplicationController

  get '/signup' do
    if !logged_in?
      erb :'/users/create_user'
    else
      redirect to '/my-library'
    end
  end

  post '/signup' do
    if params[:username] == "" || params[:email] == "" || params[:password] == "" || params[:password] != params[:password_check] || User.all.find{|email| email == params[:email]}
      flash[:message] = "Make sure you've entered a username, email, and matching passwords. If you've done these things, that email is already registered."
      redirect to '/signup'
    else
      @user = User.new(username: params[:username], email: params[:email], password: params[:password])
      @user.save
      session[:user_id] = @user.id
      redirect to '/my-library'
    end
  end

  get '/my-library' do
    if logged_in?
      @books = Book.all.find_all{|book| book.user == current_user}
      erb :'/users/library'
    else
      redirect to '/'
    end
  end

  get '/login' do
    if !logged_in?
      erb :'users/login'
    else
      redirect to '/my-library'
    end
  end

  post '/login' do
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to '/my-library'
    else
      flash[:message] = "Invalid login information."
      redirect to '/'
    end
  end

  get '/logout' do
    if logged_in?
      session.destroy
      redirect to '/login'
    else
      redirect to '/'
    end
  end

end
