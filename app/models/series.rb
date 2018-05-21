class Series < ActiveRecord::Base
  has_many :books
  belongs_to :author

end

#are we going to have problems with series ending in an "s"?
