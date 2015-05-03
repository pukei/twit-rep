class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :user_id
      t.string :email
      t.string :uid
      t.integer :plan_id
      t.datetime :start_date
      t.datetime :end_date
      t.integer :lock_version

      t.timestamps
    end
  end
end
