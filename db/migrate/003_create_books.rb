class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.string :title
      t.integer :author_id
      t.string :tags
      t.boolean :read_flag
      t.integer :times_read
      t.boolean :owned_flag
      t.string :location
      t.string :comments
      t.integer :user_id
      t.boolean :goodreads_flag
      t.string :goodreads_url
      t.string :goodreads_rating
    end
  end
end
