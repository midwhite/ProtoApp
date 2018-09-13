class DeviseCreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, null: false, default: ""
      t.string :uid
      t.string :provider

      t.string :name, default: ""
      t.integer :gender
      t.date :birthday
      t.string :area, default: ""
      t.text :profile

      t.string :access_token, null: false
      t.datetime :token_expires_at

      t.datetime :registered_at
      t.datetime :deleted_at
      t.timestamps null: false
    end

    add_index :users, [:email, :deleted_at], unique: true
    add_index :users, [:uid, :provider, :deleted_at], unique: true
  end
end
