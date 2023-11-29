# frozen_string_literal: true

class CreateMaps < ActiveRecord::Migration[7.0]
  def change
    create_table :maps, id: :uuid do |t|
      t.string :user_id, null: false
      t.string :name, null: false
      t.json :atlas, null: false, default: { version: '1', data: {} }

      t.timestamps
    end

    add_index :maps, %i[user_id name], unique: true
    add_index :maps, :user_id
  end
end
