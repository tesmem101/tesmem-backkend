class AddTrashFieldToDesign < ActiveRecord::Migration[5.1]
  def change
    add_column :designs, :is_trashed, :integer, default: 0, null: false
  end
end
