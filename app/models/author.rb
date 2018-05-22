class Author < ActiveRecord::Base
  has_many :books

  def slugify
    name.downcase.gsub(".","").gsub(" ","-")
  end

  def self.find_by_slug(slug)
    Author.all.find{|author| author.slug == slug}
  end

#  def self.find_or_create_by_slug(slug, name)
    #Author.all.find_or_create_by{|author| author.slug == slug}
#    @self.name = name
#  end

  def self.match_author(slug, name)
    Author.where(self.slugify => slug).first_or_create(name: name)
  end
end
