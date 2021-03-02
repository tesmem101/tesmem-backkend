class CreateSortReservedIcons < ActiveRecord::Migration[5.1]
  def change
    create_table :sort_reserved_icons do |t|
      t.integer :sub_category_id
      t.string :title
      t.integer :position

      t.timestamps
    end
  end
end
