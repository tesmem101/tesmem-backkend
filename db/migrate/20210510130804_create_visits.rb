class CreateVisits < ActiveRecord::Migration[5.1]
  def change
    create_table :visits do |t|
      t.references :user, foreign_key: true
      t.string :login_type
      t.string :remote_ip

      t.timestamps
    end
  end
end
