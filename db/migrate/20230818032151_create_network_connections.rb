# frozen_string_literal: true

class CreateNetworkConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :network_connections, id: :uuid do |t|
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
