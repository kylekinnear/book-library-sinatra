class Author < ActiveRecord::Base
  has_many :books

  def slug
    name.downcase.gsub(".","").gsub(" ","-")
  end

  def self.find_by_slug(slug)
    Author.all.find{|author| author.slug == slug}l
  end

  def self.find_or_create_by_slug(slug)
    Author.all.find_or_create_by{|author| author.slug == slug}
  end
end
