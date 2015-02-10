class CreateInstances < ActiveRecord::Migration
  def change
    create_table :instances do |t|
      t.string :name
      t.string :ipaddr
      t.integer :repository_id
      t.integer :host_id

      t.timestamps null: false
    end
  end
end
