class FavCount < ActiveRecord::Base
  attr_accessible :campaign_id, :tweet_id, :user_id, :impression_id

  belongs_to :user
  belongs_to :campaign
  belongs_to :impression

  def self.last_week(user=nil, week=1)
  	week = week.to_i
  	user ? where(:created_at => week.week.ago.beginning_of_week..week.week.ago.end_of_week, :user_id => user.id) : where(:created_at => week.week.ago.beginning_of_week..week.week.ago.end_of_week)
  end

  ###
  # wday => 1:mon, 2:tue, 3:wed, 4:thu, 5:fri, 6:sat, 7:sun
  def self.last_week_daywise(last_week_all, wday)
  	last_week_all.select{|x| x if x.created_at.wday==wday}
  end
end
