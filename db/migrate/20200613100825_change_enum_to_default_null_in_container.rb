class ChangeEnumToDefaultNullInContainer < ActiveRecord::Migration[5.1]
  def change
    change_column :containers, :options, :integer, null: false, default: 0
  end
end
