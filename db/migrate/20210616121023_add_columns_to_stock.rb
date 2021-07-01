class AddColumnsToStock < ActiveRecord::Migration[5.1]
  def change
    add_column :stocks, :stock_height, :string
    add_column :stocks, :stock_width, :string
  end
end
