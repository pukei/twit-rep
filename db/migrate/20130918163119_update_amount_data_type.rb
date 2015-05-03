class UpdateAmountDataType < ActiveRecord::Migration
  def up
  	remove_column :payments, :amount
  	add_column :payments, :amount, :float
  	remove_column :payments, :popup
  	add_column :payments, :popup, :boolean, :default => false
  	add_column :payments, :plan_id, :integer
  end

  def down
  end
end
