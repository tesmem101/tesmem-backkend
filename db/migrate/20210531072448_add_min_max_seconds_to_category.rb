class AddMinMaxSecondsToCategory < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :min_seconds, :integer
    add_column :categories, :max_seconds, :integer
  end
end
