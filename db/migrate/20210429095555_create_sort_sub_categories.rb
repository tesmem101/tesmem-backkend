class CreateSortSubCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :sort_sub_categories do |t|
      t.references :category, foreign_key: true
      t.references :sub_category, foreign_key: true
      t.string :sub_category_title
      t.integer :position

      t.timestamps
    end
  end
end
