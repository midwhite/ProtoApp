class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, index: true
      t.string :notification_type, null: false
      t.integer :target_id, null: false
      t.integer :link_id
      t.string :icon_url
      t.string :content
      t.datetime :opened_at

      t.timestamps
    end
  end
end
