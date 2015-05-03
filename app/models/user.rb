class User < ActiveRecord::Base
  	attr_accessible :name, :access_token, :access_token_secret, :profile_image_url
  	has_many :campaigns
  	has_many :impressions
  	has_many :fav_counts

  	has_one :account, :conditions => ["lock_version != -1"]
  	has_many :accounts

	def self.create_with_omniauth(auth)
  		create! do |user|
	    	user.provider = auth["provider"]
	    	user.uid = auth["uid"]
	    	user.name = auth["info"]["name"]
	    	user.access_token = auth["credentials"]["token"]
	    	user.access_token_secret = auth["credentials"]["secret"]
  		end
	end

	def verify_user_details(auth)
		user_info = {}
		if self.access_token != auth["credentials"]["token"] or self.access_token_secret != auth["credentials"]["secret"]
			user_info = user_info.merge({:access_token => auth["credentials"]["token"], :access_token_secret => auth["credentials"]["secret"]})
		end
		if self.profile_image_url != auth["extra"]["raw_info"]["profile_image_url"]
			user_info = user_info.merge({:profile_image_url => auth["extra"]["raw_info"]["profile_image_url"]})
		end
		if self.name != auth["info"]["name"]
			user_info = user_info.merge({:name => auth["info"]["name"]})
		end
		self.update_attributes(user_info) if !user_info.empty?
	end

	def user_twitter
		Twitter::Client.new(
		  :oauth_token => self.access_token,
		  :oauth_token_secret => self.access_token_secret
		)
	end

	def all_impressions(not_yet_followed=false)
		c = Impression.count(:id, :conditions => ["user_id = ?", self.id])
		limit = 500
		impressions = []
		offset = 0

		while(impressions.size < c and offset < c) do
			if !not_yet_followed
				impressions << self.impressions.all(:limit => limit, :offset => offset)
			else
				impressions << self.impressions.all(:limit => limit, :offset => offset, :conditions=>["followed_back = false"])
			end

			offset += limit
			impressions = impressions.flatten
		end
		impressions
	end

	def all_followers
		twitter = self.user_twitter

		followers = []

		f = twitter.followers
		followers << f.users

		while(f.next_cursor != 0) do
			f = twitter.followers(:cursor => f.next_cursor)
			followers << f.users
		end

		followers.flatten
	end

	def all_followers_ids
		twitter = self.user_twitter

		followers = []

		f = twitter.follower_ids
		followers << f.ids

		while(f.next_cursor != 0) do
			f = twitter.follower_ids(:cursor => f.next_cursor)
			followers << f.ids
		end

		followers.flatten
	end

	def followed_back_marker
		impressions = self.all_impressions(true)
		f_ids = self.all_followers_ids
		impressions.each do |i|
			if f_ids.include?(i.to_follow_id.to_i)
				i.update_attribute(:followed_back, true)
			end
		end
	end

	# twitter.retweet(t.id)
	# twitter.follow(t.user.id)
	# twitter.update("Tweeting from TwitRep!")
	def campaign_in_twitter
		twitter = self.user_twitter

		campaigns = self.campaigns
		t_count = ((self.account.plan.monthly_impressions rescue 500)/((campaigns.size rescue 1) * 5 *30)).to_i
		campaigns.each do |c|

			limit = t_count-100
			tweets = []
			t = twitter.search("#{c.campaign}", :count => t_count)
			tweets << t.results
			while(limit > 0) do
				t = twitter.search("#{c.campaign}", :count => limit)
				tweets << t.results
				limit = limit-100
			end
			tweets = tweets.flatten
			
			# tweets = twitter.search("#{c.campaign}", :count => 1).results

			i_count = 0
			tweets.each do |t|
				i = Impression.find(:first, :select => "id", :conditions => ["campaign_id = ? and to_follow_id = ? ", c.id, t.user.id.to_s])

				i = i.nil? ? Impression.create({:campaign_id => c.id, :to_follow_id => t.user.id.to_s, 
					:to_follow_name => t.user.name, :user_id => self.id, }) : i
				
				fc = FavCount.find(:first, :conditions => ["impression_id = ? and tweet_id = ?", i.id, t.id.to_s])
				if( fc.nil? )
					FavCount.create({:campaign_id => c.id, :user_id => self.id, :impression_id => i.id, :tweet_id => t.id.to_s})
					i_count += 1
				end
			end

			i_count = (c.impressions_count ? (c.impressions_count+i_count) : i_count)
			c.update_attribute('impressions_count', i_count) if i_count > 0
		end
	end
end
