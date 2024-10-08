# frozen_string_literal: true

class CreateNetworkUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :network_users, id: :uuid do |t|
      t.string :user_id
      t.integer :role
      t.references :connection, null: false, foreign_key: { to_table: :network_connections }, type: :uuid

      t.timestamps
    end

    add_index :network_users, :user_id
  end
end
