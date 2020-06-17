class AddWidthFieldToDesign < ActiveRecord::Migration[5.1]
  def change
    add_column :designs, :width, :string
  end
end
