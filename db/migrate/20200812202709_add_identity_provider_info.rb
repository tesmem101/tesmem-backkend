class AddIdentityProviderInfo < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :identity_provider, :integer, default: 0
    add_column :users, :identity_provider_id, :integer, default: nil
  end
end
