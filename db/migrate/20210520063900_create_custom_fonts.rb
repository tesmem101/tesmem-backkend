class CreateCustomFonts < ActiveRecord::Migration[5.1]
  def change
    create_table :custom_fonts do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.string :file

      t.timestamps
    end
  end
end
