class AddCategoryIdToDesigns < ActiveRecord::Migration[5.1]
  def change
    add_column :designs, :cat_id, :integer, default: nil
  end
end
