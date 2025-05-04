class CreateContactTags < ActiveRecord::Migration[7.1]
  def change
    create_table :contact_tags do |t|
      t.references :contact, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      t.timestamps
    end
    add_index :contact_tags, [:contact_id, :tag_id], unique: true
  end
end 