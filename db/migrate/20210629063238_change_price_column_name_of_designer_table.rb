class ChangePriceColumnNameOfDesignerTable < ActiveRecord::Migration[5.1]
  def change
    rename_column :designers, :price, :rate_per_design
  end
end
