class CreateTemplateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :template_tags do |t|
      t.references :designer, foreign_key: true
      t.references :tag, foreign_key: true
      t.timestamps
    end
  end
end
