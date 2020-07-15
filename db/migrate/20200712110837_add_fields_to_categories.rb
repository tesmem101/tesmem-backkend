class AddFieldsToCategories < ActiveRecord::Migration[5.1]
  def change
    add_reference :categories, :super_category, index: true
    add_column :categories, :cover, :string
  end
end
