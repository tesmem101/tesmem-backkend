class CreateContainers < ActiveRecord::Migration[5.1]
  def change
    create_table :containers do |t|
      t.integer :folder_id
      t.integer :type_id
      t.string [:design, :image]
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
