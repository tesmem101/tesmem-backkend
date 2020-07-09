class AddImageFieldToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :profile, :string
    add_column :users, :identity_provider_profile, :string
  end
end
