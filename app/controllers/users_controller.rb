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
      erb :'/users/library'
    else
      redirect to '/login'
    end
  end

end
