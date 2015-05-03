class CreatePayments < ActiveRecord::Migration
  def change
  	create_table :payments do |t|
      t.float :amount
      t.integer :account_id
      t.string :token, :identifier, :payer_id
      t.boolean :popup, :completed, :canceled, default: false
      t.boolean :digital, :recurring, default: true

      t.timestamps
    end
  end
end