class AddArabicFieldToStocks < ActiveRecord::Migration[5.1]
  def change
    add_column :stocks, :title_ar, :string
  end
end
