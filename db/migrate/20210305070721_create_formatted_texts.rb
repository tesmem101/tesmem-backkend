class CreateFormattedTexts < ActiveRecord::Migration[5.1]
  def change
    create_table :formatted_texts do |t|
      t.references :user, foreign_key: true
      t.json :style, default: {} 
      t.boolean :approved, default: false
      t.integer :approvedBy_id
      t.integer :unapprovedBy_id

      t.timestamps
    end
  end
end
