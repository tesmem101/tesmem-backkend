class AddSvgToStocks < ActiveRecord::Migration[5.1]
  def change
    add_column :stocks, :svg, :string
    remove_column :stocks, :stocktype
    add_column :stocks, :stocktype, :integer, default: 0
  end
end
