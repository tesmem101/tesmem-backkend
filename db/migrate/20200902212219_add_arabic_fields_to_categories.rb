class AddArabicFieldsToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :title_ar, :string
    add_column :sub_categories, :title_ar, :string
  end
end
