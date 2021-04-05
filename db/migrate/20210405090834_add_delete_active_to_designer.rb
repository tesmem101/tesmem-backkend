class AddDeleteActiveToDesigner < ActiveRecord::Migration[5.1]
  def change
    add_column :designers, :is_deleted, :boolean, default: false
    add_column :designers, :is_active, :boolean, default: true
  end
end
