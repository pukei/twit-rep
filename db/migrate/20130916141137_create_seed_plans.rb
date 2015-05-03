class CreateSeedPlans < ActiveRecord::Migration
  def up
  	plans = ["Free", "FanBase Basic", "FanBase Premium", "FanBase Black"]
  	f = ["1 month trial plan", "Basic Targeting | Get Fans", "Advanced Targeting | Get More Fans", "Advanced Targeting | Get An Army Of Fans | Beta Feature Access | Personal Account Manager | Extended Support | Assistance Setting Up Campaigns"]
  	p = [0, 19.95, 39.95, 99.95]
  	mi = [500, 5000, 9000, 15000]

  	plans.each_with_index do |t, i|
  		Plan.create({:title => t, :summary => f[i], :monthly_impressions => mi[i], :price => p[i]})
  	end
  end

  def down
  end
end
