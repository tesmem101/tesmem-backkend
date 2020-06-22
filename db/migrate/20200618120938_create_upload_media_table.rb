class CreateUploadMediaTable < ActiveRecord::Migration[5.1]
  def change
    create_table :uploads do |t|
      t.integer :user_id, index: true, null: false
      t.string :image, null: false
      t.string :title
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
