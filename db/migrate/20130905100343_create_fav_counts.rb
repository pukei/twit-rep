class CreateFavCounts < ActiveRecord::Migration
  def change
    create_table :fav_counts do |t|
      t.string :tweet_id
      t.integer :campaign_id
      t.integer :user_id
      t.integer :impression_id

      t.timestamps
    end
  end
end
