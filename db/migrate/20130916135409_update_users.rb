class UpdateUsers < ActiveRecord::Migration
  def up
  	add_column :users, :profile_image_url, :string
  	remove_column :users, :daily_limit  end

  def down
  end
end
