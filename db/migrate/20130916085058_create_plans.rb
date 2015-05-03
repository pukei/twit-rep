class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :title
      t.float :price
      t.text :summary
      t.integer :monthly_impressions, :default => 500

      t.timestamps
    end
  end
end
