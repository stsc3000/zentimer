class AddEntriesToUser < ActiveRecord::Migration
  def change
    add_column :users, :entries, :json
  end
end
