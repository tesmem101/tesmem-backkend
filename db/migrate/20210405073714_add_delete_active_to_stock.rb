class AddDeleteActiveToStock < ActiveRecord::Migration[5.1]
  def change
    add_column :stocks, :is_deleted, :boolean, default: false
    add_column :stocks, :is_active, :boolean, default: true
  end
end
