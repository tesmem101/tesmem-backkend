class AddColorsToStocks < ActiveRecord::Migration[5.1]
  def change
    add_column :stocks, :colors, :string
  end
end
