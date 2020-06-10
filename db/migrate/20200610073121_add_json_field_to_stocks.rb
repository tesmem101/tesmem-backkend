class AddJsonFieldToStocks < ActiveRecord::Migration[5.1]
  def change
    add_column :stocks, :json, :json
  end
end
