class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :tags
      t.boolean :read?
      t.integer :times_read
      t.boolean :owned?
      t.string :location
      t.string :series
      t.string :comments
      t.boolean :goodreads_flag
      t.string :goodreads_url
      t.integer :goodreads_rates
      t.float :goodreads_rating
    end
  end
end
