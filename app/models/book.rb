class Book < ActiveRecord::Base
  belongs_to :user
  belongs_to :author
  has_many :tags

  #we need to pass 3 things out:
  #1. the url of the item page as a string (book.goodreads_url)
  #2. the number of ratings the book has (book.goodreads_rates)
  #3. the average rating of the book (book.goodreads_rating)
  def scrape(book)
    search_string = "#{book.title} #{book.author.gsub(".", ". ").gsub(/[^\w\s]/,"")}".gsub(/[^a-zA-Z0-9']+/, "+")
    search_page = Nokogiri::HTML(open("https://www.goodreads.com/search?q=#{search_string}&search_type=books",'User-Agent' => 'Ruby'))
    if search_page.css("table a").size != 0
      determinant = search_page.css("span.minirating").map.with_index {|i,index| [index, i.text.strip.slice(/\s(\d|,)+/).strip.gsub(",","").to_i]}.sort! {|x,y| x[1].to_i <=> y[1].to_i}.last
      item_page = Nokogiri::HTML(open("https://goodreads.com/#{search_page.css("table a.bookTitle")[determinant[0]].attribute("href").value}",'User-Agent' => 'Ruby').read)
      book.rating = item_page.search("span.average").text #average rating
      book.rates = item_page.search("span.votes.value-title").text.strip #number of ratings
    end
  end

end
