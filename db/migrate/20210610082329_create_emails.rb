class CreateEmails < ActiveRecord::Migration[5.1]
  def change
    create_table :emails do |t|
      t.string :from
      t.string :to
      t.string :title
      t.string :body
      t.timestamp :sent_at
      t.integer :type

      t.timestamps
    end
  end
end
