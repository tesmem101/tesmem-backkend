class RemoveEnumFromContainers < ActiveRecord::Migration[5.1]
  def change
    remove_column :containers, [:design, :image], :string
  end
end
