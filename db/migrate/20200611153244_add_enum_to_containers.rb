class AddEnumToContainers < ActiveRecord::Migration[5.1]
  def change
    add_column :containers, :options, :integer
  end
end
