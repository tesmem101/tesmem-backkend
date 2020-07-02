class CreateStocks < ActiveRecord::Migration[5.1]
  def change
    create_table :stocks do |t|
      t.string :title
      t.text :description
      t.string :path
      t.integer :category_id
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end