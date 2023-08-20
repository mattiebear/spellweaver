# frozen_string_literal: true

class CreateConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :connections, id: :uuid do |t|
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
