class AddImageFieldToStocks < ActiveRecord::Migration[5.1]
  def change
    add_column :stocks, :image, :string
    add_column :stocks, :width, :string
  end
end
