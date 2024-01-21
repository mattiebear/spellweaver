class CreateBundles < ActiveRecord::Migration[7.0]
  def change
    create_table :bundles, id: :uuid do |t|

      t.timestamps
    end
  end
end
