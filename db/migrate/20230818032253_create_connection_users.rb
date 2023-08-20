# frozen_string_literal: true

class CreateConnectionUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :connection_users, id: :uuid do |t|
      t.string :user_id
      t.integer :role
      t.references :connection, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :connection_users, :user_id
  end
end
