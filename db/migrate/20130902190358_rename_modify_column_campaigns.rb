class RenameModifyColumnCampaigns < ActiveRecord::Migration
  def up
  	 rename_column :campaigns, :impressions, :impressions_count
  	 rename_column :campaigns, :follows, :follows_count
  	 remove_column :campaigns, :conversions
  end

  def down
  end
end
