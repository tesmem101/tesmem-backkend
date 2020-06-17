class ChangesToImages < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :image_id, :integer
    add_column :images, :image_type, :string
    add_column :images, :url, :string
    add_column :images, :version, :integer, default: 1
    add_column :images, :height, :string
    add_column :images, :width, :string
    rename_column :images, :pata, :description
  end
end
