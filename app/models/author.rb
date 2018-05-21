class Author < ActiveRecord::Base
  has_many :books, :series
end
