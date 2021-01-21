class CreateStockTags < ActiveRecord::Migration[5.1]
  def change
    create_table :stock_tags do |t|
      t.references :stock, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
