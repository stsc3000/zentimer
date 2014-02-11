class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :elapsed
      t.datetime :lastTick
      t.text :description
      t.boolean :running
      t.boolean :current
      t.integer :user_id

      t.timestamps
    end
  end
end
