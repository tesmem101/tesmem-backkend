class AddImageFieldToDesigns < ActiveRecord::Migration[5.1]
  def change
    add_column :designs, :image, :string
  end
end
