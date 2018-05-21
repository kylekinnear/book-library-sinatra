class CreateSeries < ActiveRecord::Migration[5.1]
  def change
    create_table :series do |t|
      t.string :series_name
      t.integer :author_id
    end
  end
end
