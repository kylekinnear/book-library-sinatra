class Author < ActiveRecord::Base
  has_many :books

  def slugify
    name.downcase.gsub(".","").gsub(" ","-")
  end

  def self.match_author(slug, name)
    Author.where(:slug => slug).first_or_create(name: name)
  end
end
