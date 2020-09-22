class AddUrlToDesigner < ActiveRecord::Migration[5.1]
  def change
    add_column :designers, :url, :string
  end
end
