class AddReferenceAsParentToFolders < ActiveRecord::Migration[5.1]
  def change
    add_reference :folders, :parent, index: true
  end
end
