class CreateMappingTableContainers < ActiveRecord::Migration[5.1]
  def change
    create_table :containers do |t|
      t.integer :folder_id, index: true, null: false
      t.integer :instance_id, index: true, null: false
      t.string  :instance_type, index: true, null: false
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
