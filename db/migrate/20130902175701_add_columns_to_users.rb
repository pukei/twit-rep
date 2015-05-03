class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :daily_limit, :integer, :default => 100
    add_column :users, :campaign_count, :integer, :default => 7
  end
end
