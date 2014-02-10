class RemoveEntriesFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :entries
  end
end
