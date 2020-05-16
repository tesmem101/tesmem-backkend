class AddSubcategoryToStock < ActiveRecord::Migration[5.1]
  def change
    change_table :stocks do |t|
      t.integer :sub_category_id, default: 0, null: false
    end
  end
end
