class AddPriceToDesign < ActiveRecord::Migration[5.1]
  def change
    add_column :designs, :price, :float
  end
end
