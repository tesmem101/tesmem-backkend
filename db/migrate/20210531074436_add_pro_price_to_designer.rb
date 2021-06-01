class AddProPriceToDesigner < ActiveRecord::Migration[5.1]
  def change
    add_column :designers, :pro, :boolean
    add_column :designers, :price, :float
  end
end
