class CreateUsedDesigns < ActiveRecord::Migration[5.1]
  def change
    create_table :used_designs do |t|
      t.references :user, foreign_key: true
      t.references :design, foreign_key: true
      t.integer :used_by

      t.timestamps
    end
  end
end
