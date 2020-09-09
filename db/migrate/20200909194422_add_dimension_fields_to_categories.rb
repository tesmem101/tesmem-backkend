class AddDimensionFieldsToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :width, :string
    add_column :categories, :height, :string
    add_column :categories, :unit, :string
  end
end
