require 'spec_helper'

describe ApplicationController do
  describe "Homepage" do
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      #expect(last_response.body).to include ("Welcome to Book Library")
  end

  describe "Sign Up" do
    it 'loads the sign up page' do
      get '/signup'
      expect(last_response.status).to eq(200)
    end
    it 'directs user to index' do
      params = {
        :username => "lorem",
        :email => "loremipsum@theinternet.com"
        :password => "ipsum"
      }
      post '/signup', params
      expect(last_response.location).to include("/index")
end
