class InfoScraper
  def scrape(title, author)
    search_string = "#{title} #{author.gsub(".", ". ").gsub(/[^\w\s]/,"")}".gsub(/[^a-zA-Z0-9']+/, "+")
    search_page = Nokogiri::HTML(open("https://www.goodreads.com/search?q=#{search_string}&search_type=books",'User-Agent' => 'Ruby'))
    if search_page.css("table a").size != 0
      determinant = search_page.css("span.minirating").map.with_index {|i,index| [index, i.text.strip.slice(/\s(\d|,)+/).strip.gsub(",","").to_i]}.sort! {|x,y| x[1].to_i <=> y[1].to_i}.last
      item_page = Nokogiri::HTML(open("https://goodreads.com/#{search_page.css("table a.bookTitle")[determinant[0]].attribute("href").value}",'User-Agent' => 'Ruby').read)
      book.rating = item_page.search("span.average").text #average rating
      book.rates = item_page.search("span.votes.value-title").text.strip #number of ratings
    end
  end
