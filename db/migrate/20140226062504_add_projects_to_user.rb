class AddProjectsToUser < ActiveRecord::Migration
  def change
    add_column :users, :projects, :text
  end
end
