class AddHeightFieldToDesign < ActiveRecord::Migration[5.1]
  def change
    add_column :designs, :height, :string
  end
end
