class AddDeleteActiveToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_deleted, :boolean, default: false
    add_column :users, :is_active, :boolean, default: true
  end
end
