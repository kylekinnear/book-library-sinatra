class Book < ActiveRecord::Base
  belongs_to :user
  belongs_to :author
  has_many :tags


  def scrape
    if @self.goodreads_flag == 1
      search_string = "#{@self.title} #{@self.author.gsub(".", ". ").gsub(/[^\w\s]/,"")}".gsub(/[^a-zA-Z0-9']+/, "+")
      search_page = Nokogiri::HTML(open("https://www.goodreads.com/search?q=#{search_string}&search_type=books",'User-Agent' => 'Ruby'))
      if search_page.css("table a").size != 0
        determinant = search_page.css("span.minirating").map.with_index {|i,index| [index, i.text.strip.slice(/\s(\d|,)+/).strip.gsub(",","").to_i]}.sort! {|x,y| x[1].to_i <=> y[1].to_i}.last
        @self.goodreads_url = "https:goodreads.com#{search_page.css("table a.bookTitle")[determinant[0]].attribute("href").value}"

        @self.goodreads_rating = search_page.css("span.minirating").text
        #this needs testing and to use the determinant to make sure it grabs the right entry

      end
    end
  end

end
