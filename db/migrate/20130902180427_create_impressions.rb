class CreateImpressions < ActiveRecord::Migration
  def change
    create_table :impressions do |t|
      t.integer :campaign_id
      t.integer :user_id
      t.string :to_follow_id
      t.string :to_follow_name
      t.boolean :followed_back, :default => false

      t.timestamps
    end
  end
end
