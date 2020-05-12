class CreateDesigns < ActiveRecord::Migration[5.1]
  def change
    create_table :designs do |t|
      t.string :title
      t.string :description
      t.json :styles
      t.integer :user_id

      t.index :user_id,                     name: :design_by_user
      t.timestamps
    end
  end
end
