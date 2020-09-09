class RemoveFieldsFromStocks < ActiveRecord::Migration[5.1]
  def change
    remove_column :stocks, :size
    remove_column :stocks, :height
    remove_column :stocks, :width
  end
end
