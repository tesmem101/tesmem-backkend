class AddIndexingInTitles < ActiveRecord::Migration[5.1]
  def change
    add_index :categories, :title
    add_index :sub_categories, :title
  end
end
