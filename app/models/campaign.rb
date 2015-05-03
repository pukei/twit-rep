class Campaign < ActiveRecord::Base
  attr_accessible :campaign, :follows_count, :impressions_count, :user_id
  belongs_to :user
  has_many :impressions
  has_many :fav_counts

  def self.add_update_campaigns(params, current_user)
  	campaigns = params["campaigns"].select{|x| x if !x.empty?}
  	# Rails.logger.info "@@@ #{campaigns.inspect}"
  	
    old_campaigns = current_user.campaigns.find(:all, :select => "id").map(&:id)
    retained_campaigns = []

  	campaigns.each do |c|
  		campaign = find(:first, :select => "id", :conditions => ["user_id = ? and campaign = ?", current_user.id, c])
      retained_campaigns << campaign.id if campaign
  		create({:campaign => c, :user_id => current_user.id}) if !campaign
  	end

    deleted_campaigns = old_campaigns - retained_campaigns

    # Rails.logger.info "@@@ #{old_campaigns.inspect} : #{retained_campaigns.inspect} : #{deleted_campaigns.inspect}"
    Campaign.delete_all(["id IN (?)", deleted_campaigns]) if !deleted_campaigns.empty?
  end
end
