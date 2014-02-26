class AddTagsToUser < ActiveRecord::Migration
  def change
    add_column :users, :tags, :text
  end
end
