class AddClipPathToStock < ActiveRecord::Migration[5.1]
  def change
    add_column :stocks, :clip_path, :string
  end
end
