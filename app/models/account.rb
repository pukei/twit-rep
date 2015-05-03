class Account < ActiveRecord::Base
  attr_accessible :end_date, :lock_version, :plan_id, :start_date, :uid, :user_id

  belongs_to :plan
  has_one :payment

  def self.create_new_account(current_user, plan_id=nil)
  	a = current_user.account
    a_new = Account.new({:user_id => current_user.id, :uid => current_user.uid, :plan_id => (plan_id || Plan.first.id), :start_date => Time.now})
    a_new.email = a.email
    a_new.save

    begin
       Account.update_all("lock_version = -1", "id=#{a.id}")
    rescue Exception => e
      Rails.logger.info "@@@ @@ @ #{e.message}"
    end
    a_new
  end
end
