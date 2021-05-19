class CreateDeletedAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :deleted_accounts do |t|
      t.string :user_email
      t.string :reason

      t.timestamps
    end
  end
end
