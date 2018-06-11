class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.string :title
      t.integer :author_id
      t.string :location
      t.string :comments
      t.integer :user_id
    end
  end
end
