class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.integer :user_id
      t.string :campaign
      t.integer :impressions
      t.decimal :conversions
      t.integer :follows

      t.timestamps
    end
  end
end
