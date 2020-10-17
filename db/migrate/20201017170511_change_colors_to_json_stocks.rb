class ChangeColorsToJsonStocks < ActiveRecord::Migration[5.1]
  def change
    add_column :stocks, :specs, :json
    remove_column :stocks, :colors
  end
end
