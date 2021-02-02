class AddSvgThumbToStocks < ActiveRecord::Migration[5.1]
  def change
    add_column :stocks, :svg_thumb, :string
  end
end
