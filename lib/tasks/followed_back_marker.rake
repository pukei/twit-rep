task :followed_back_marker => :environment do
  p "started"
  c = User.count(:id)
  limit = 500
  users = []
  offset = 0

  while(users.size < c and offset < c) do
    us = User.all(:limit => limit, :offset => offset)

    us.each do |u|
      begin
        u.campaign_in_twitter
      rescue
      end
      u.followed_back_marker
    end

    users << us
    offset += limit
    users = users.flatten
  end


  c = Campaign.count(:id)
  limit = 500
  campaigns = []
  offset = 0

  while(campaigns.size < c and offset < c) do
    cs = Campaign.all(:limit => limit, :offset => offset)

    cs.each do |c|
      c_followed_back = c.impressions.count(:id, :conditions => ["followed_back = true"])
      c.update_attribute(:follows_count, c_followed_back)
    end

    campaigns << cs
    offset += limit
    campaigns = campaigns.flatten
  end
  p "done"
end
