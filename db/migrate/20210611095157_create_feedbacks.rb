class CreateFeedbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :feedbacks do |t|
      t.references :user, foreign_key: true
      t.boolean :happy
      t.string :feedback

      t.timestamps
    end
  end
end
