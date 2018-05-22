lrequire 'spec_helper'

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

    it 'does not let a user sign up without a username' do
      params = {
        :username => "",
        :email => "loremipsum@theinternet.com",
        :password => "ipsum"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without an email' do
      params = {
        :username => "lorem",
        :email => "",
        :password => "ipsum"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without a password' do
      params = {
        :username => "lorem",
        :email => "loremipsum@theinternet.com",
        :password => ""
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a logged in user view the signup page' do
      user = User.create(:username => "lorem", :email => "loremipsum@theinternet.com", :password => "ipsum")
      params = {
        :username => "lorem",
        :email => "loremipsum@theinternet.com"
        :password => "ipsum"
      }
      post '/signup', params
      session = {}
      session[:user_id] = user.id
      get '/signup'
      expect(last_response.location).to include('/index')
    end







    describe "login" do
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it 'loads the index after login' do
      user = User.create(:username => "lorem", :email => "loremipsum@theinternet.com", :password => "ipsum")
      params = {
        :username => "lorem",
        :password => "ipsum"
      }
      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome,")
    end

    it 'does not let user view login page if already logged in' do
      user = User.create(:username => "lorem", :email => "loremipsum@theinternet.com", :password => "ipsum")
      params = {
        :username => "lorem",
        :password => "ipsum"
      }
      post '/login', params
      session = {}
      session[:user_id] = user.id
      get '/login'
      expect(last_response.location).to include("/index")
    end
  end

  describe "logout" do
    it "lets a user logout if they are already logged in" do
      user = User.create(:username => "lorem", :email => "loremipsum@theinternet.com", :password => "ipsum")
      params = {
        :username => "lorem",
        :password => "ipsum"
      }
      post '/login', params
      get '/logout'
      expect(last_response.location).to include("/login")
    end

    it 'does not let a user logout if not logged in' do
      get '/logout'
      expect(last_response.location).to include("/")
    end

    it 'does not load /index if user not logged in' do
      get '/index'
      expect(last_response.location).to include("/login")
    end

    it 'does load /index if user is logged in' do
      user = User.create(:username => "lorem", :email => "loremipsum@theinternet.com", :password => "ipsum")

      visit '/login'

      fill_in(:username, :with => "lorem")
      fill_in(:password, :with => "ipsum")
      click_button 'submit'
      expect(page.current_path).to eq('/index')
    end
  end

  describe 'user show page' do
    it 'shows all a single users books' do
      user = User.create(:username => "lorem", :email => "loremipsum@theinternet.com", :password => "ipsum")
      book1 = Book.create(:title => "Harry Potter and the Sorcerer's Stone", :author => "JK Rowling", :genre => "Fantasy", :user_id => user.id)
      book2 = Book.create(:title => "Oliver Twist", :author => "Charles Dickens", :genre => "Classic", :user_id => user.id)
      get "/users/#{user.slug}"

      expect(last_response.body).to include("Harry Potter and the Sorcerer's Stone")
      expect(last_response.body).to include("JK Rowling")
      expect(last_response.body).to include("Oliver Twist")
      expect(last_response.body).to include("Charles Dickens")
    end
  end




#check these specs
  describe 'index action' do
    context 'logged in' do
      it 'lets a user view the tweets index if logged in' do
        user = User.create(:username => "lorem", :email => "loremipsum@theinternet.com", :password => "ipsum")
        book1 = Book.create(:title => "Harry Potter and the Sorcerer's Stone", :author => "JK Rowling", :genre => "Fantasy", :user_id => user.id)

        user2 = User.create(:username => "dolor", :email => "dolorsit@theinternet.com", :password => "sit")
        book2 = Book.create(:title => "Oliver Twist", :author => "Charles Dickens", :genre => "Classic", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "lorem")
        fill_in(:password, :with => "ipsum")
        click_button 'submit'
        visit "/index"
        expect(page.body).to include(book1.title)
        expect(page.body).to include(book2.title)
      end
    end

    context 'logged out' do
      it 'does not let a user view the tweets index if not logged in' do
        get '/index'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'new action' do
    context 'logged in' do
      it 'lets user view new book form if logged in' do
        user = User.create(:username => "lorem", :email => "loremipsum@theinternet.com", :password => "ipsum")

        visit '/login'

        fill_in(:username, :with => "lorem")
        fill_in(:password, :with => "ipsum")
        click_button 'submit'
        visit '/books/new'
        expect(page.status_code).to eq(200)
      end

      it 'lets user create a book if they are logged in' do
        user = User.create(:username => "lorem", :email => "loremipsum@theinternet.com", :password => "ipsum")

        visit '/login'

        fill_in(:username, :with => "lorem")
        fill_in(:password, :with => "ipsum")
        click_button 'submit'

        visit '/books/new'
        fill_in(:title, :with => "The Odyssey")
        click_button 'submit'

        user = User.find_by(:username => "lorem")
        book = Book.find_by(:title => "The Odyssey")
        expect(book).to be_instance_of(Book)
#how do we reconcile users both having the same book?
#        expect(book.user_id).to eq(user.id)
        expect(page.status_code).to eq(200)
      end

#      it 'does not let a user tweet from another user' do
#        user = User.create(:username => "lorem", :email => "loremipsum@theinternet.com", :password => "ipsum")
#        user2 = User.create(:username => "dolor", :email => "dolorsit@theinternet.com", :password => "sit")

#        visit '/login'

#        fill_in(:username, :with => "becky567")
#        fill_in(:password, :with => "kittens")
#        click_button 'submit'

#        visit '/tweets/new'

#        fill_in(:content, :with => "tweet!!!")
#        click_button 'submit'

#        user = User.find_by(:id=> user.id)
#        user2 = User.find_by(:id => user2.id)
#        tweet = Tweet.find_by(:content => "tweet!!!")
#        expect(tweet).to be_instance_of(Tweet)
#        expect(tweet.user_id).to eq(user.id)
#        expect(tweet.user_id).not_to eq(user2.id)
#      end

      it 'does not let a user create a blank title or author' do
        user = User.create(:username => "lorem", :email => "loremipsum@theinternet.com", :password => "ipsum")

        visit '/login'

        fill_in(:username, :with => "lorem")
        fill_in(:password, :with => "ipsum")
        click_button 'submit'

        visit '/books/new'

        fill_in(:title, :with => "")
        fill_in(:author, :with => "")
        click_button 'submit'

        expect(Book.find_by(:title => "")).to eq(nil)
        expect(Book.find_by(:author => "")).to eq(nil)
        expect(page.current_path).to eq("/books/new")
      end
    end

    context 'logged out' do
      it 'does not let user view new tweet form if not logged in' do
        get '/books/new'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'show action' do
    context 'logged in' do
      it 'displays a single book' do

        user = User.create(:username => "lorem", :email => "loremipsum@theinternet.com", :password => "ipsum")
        book = Book.create(:title => "Harry Potter and the Sorcerer's Stone", :author => "JK Rowling", :genre => "Fantasy", :user_id => user.id)

        visit '/login'

        fill_in(:username, :with => "lorem")
        fill_in(:password, :with => "ipsum")
        click_button 'submit'

        visit "/books/#{book.id}"
        expect(page.status_code).to eq(200)
#        expect(page.body).to include("Delete Book")
        expect(page.body).to include(book.title)
        expect(page.body).to include(book.author)
#        expect(page.body).to include("Edit Book")
      end
    end

    context 'logged out' do
      it 'does not let a user view a book' do
        user = User.create(:username => "lorem", :email => "loremipsum@theinternet.com", :password => "ipsum")
        book = Book.create(:title => "Harry Potter and the Sorcerer's Stone", :author => "JK Rowling", :genre => "Fantasy", :user_id => user.id)
        get "/books/#{book.id}"
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'edit action' do
    context "logged in" do
      it 'lets a user view book edit form if they are logged in' do
        user = User.create(:username => "lorem", :email => "loremipsum@theinternet.com", :password => "ipsum")
        book = Book.create(:title => "Harry Potter and the Sorcerer's Stone", :author => "JK Rowling", :genre => "Fantasy", :user_id => user.id)
        visit '/login'

        fill_in(:username, :with => "lorem")
        fill_in(:password, :with => "ipsum")
        click_button 'submit'
        visit '/books/1/edit'
        expect(page.status_code).to eq(200)
        expect(page.body).to include(book.title)
        expect(page.body).to include(book.author)
      end

      it 'does not let a user edit a book they did not create' do
        user = User.create(:username => "lorem", :email => "loremipsum@theinternet.com", :password => "ipsum")
        book = Book.create(:title => "Harry Potter and the Sorcerer's Stone", :author => "JK Rowling", :genre => "Fantasy", :user_id => user.id)

        user2 = User.create(:username => "dolor", :email => "dolorsit@theinternet.com", :password => "sit")
        book2 = Book.create(:title => "Oliver Twist", :author => "Charles Dickens", :genre => "Classic", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "lorem")
        fill_in(:password, :with => "ipsum")
        click_button 'submit'
        session = {}
        session[:user_id] = user1.id
        visit "/books/#{book2.id}/edit"
        expect(page.current_path).to include('/books')
      end

      it 'lets a user edit their own book if they are logged in' do
        user = User.create(:username => "lorem", :email => "loremipsum@theinternet.com", :password => "ipsum")
        book = Book.create(:title => "Harry Potter and the Sorcerer's Stone", :author => "JK Rowling", :genre => "Fantasy", :user_id => user.id)
        visit '/login'

        fill_in(:username, :with => "lorem")
        fill_in(:password, :with => "ipsum")
        click_button 'submit'
        visit "/books/#{book.id}/edit"

        fill_in(:title, :with => "Harry Potter 1")

        click_button 'submit'
        expect(Book.find_by(:title => "Harry Potter 1")).to be_instance_of(Tweet)
        expect(Book.find_by(:title => "Harry Potter and the Sorcerer's Stone")).to eq(nil)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user edit a text with blank content' do
        user = User.create(:username => "lorem", :email => "loremipsum@theinternet.com", :password => "ipsum")
        book = Book.create(:title => "Harry Potter and the Sorcerer's Stone", :author => "JK Rowling", :genre => "Fantasy", :user_id => user.id)
        visit '/login'

        fill_in(:username, :with => "lorem")
        fill_in(:password, :with => "ipsum")
        click_button 'submit'
        visit "/books/#{book.id}/edit"

        fill_in(:title, :with => "")
# =>    Add checks for other fields?
        click_button 'submit'
        expect(Book.find_by(:title => "Harry Potter and the Sorcerer's Stone")).to be(nil)
        expect(page.current_path).to eq("/books/#{book.id}/edit")
      end
    end

    context "logged out" do
      it 'does not load let user view book edit form if not logged in' do
        get '/books/1/edit'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'delete action' do
    context "logged in" do
      it 'lets a user delete their own book if they are logged in' do
        user = User.create(:username => "lorem", :email => "loremipsum@theinternet.com", :password => "ipsum")
        book = Book.create(:title => "Harry Potter and the Sorcerer's Stone", :author => "JK Rowling", :genre => "Fantasy", :user_id => user.id)
        visit '/login'

        fill_in(:username, :with => "lorem")
        fill_in(:password, :with => "ipsum")
        click_button 'submit'
        visit "/books/#{book.id}"
        click_button "Delete Book"
        expect(page.status_code).to eq(200)
        expect(Book.find_by(:title => "Harry Potter and the Sorcerer's Stone")).to be(nil)
      end

      it 'does not let a user delete a tweet they did not create' do
        user = User.create(:username => "lorem", :email => "loremipsum@theinternet.com", :password => "ipsum")
        book = Book.create(:title => "Harry Potter and the Sorcerer's Stone", :author => "JK Rowling", :genre => "Fantasy", :user_id => user.id)

        user2 = User.create(:username => "dolor", :email => "dolorsit@theinternet.com", :password => "sit")
        book2 = Book.create(:title => "Oliver Twist", :author => "Charles Dickens", :genre => "Classic", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "lorem")
        fill_in(:password, :with => "ipsum")
        click_button 'submit'
        visit "books/#{book2.id}"
        click_button "Delete Book"
        expect(page.status_code).to eq(200)
        expect(Tweet.find_by(:title => "Oliver Twist")).to be_instance_of(Book)
        expect(page.current_path).to include('/books')
      end
    end

    context "logged out" do
      it 'does not load a book if not logged in' do
        book = Book.create(:title => "Harry Potter and the Sorcerer's Stone", :author => "JK Rowling", :genre => "Fantasy", :user_id => 1)
        visit '/books/1'
        expect(page.current_path).to eq("/login")
      end
    end
  end
end
