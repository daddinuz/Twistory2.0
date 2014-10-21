class AddPermissionLevelToUsers < ActiveRecord::Migration
  def change
    add_column :users, :permission_level, :integer, :default => 100
  end
end
