class UsersController < ApplicationController
	skip_filter :login_required, :only => [:home]

	def home
		# auth = request.env["omniauth.auth"]
		# Rails.logger.info "@@@ #{auth.inspect}"
	  	# Rails.logger.info "@@@ #{request.inspect}"
	end

	def campaigns
		Campaign.add_update_campaigns(params, current_user) if request.post?

		# Thread.new{ current_user.campaign_in_twitter }
		# current_user.campaign_in_twitter
		
		@impressions = FavCount.last_week(current_user)
		@followers = Impression.last_week_followed_back(current_user)
		@campaigns = Campaign.find(:all, :conditions => ["user_id = ?", current_user.id])
	end

	def analytics
		@impressions = FavCount.last_week(current_user, params[:week])
		@followers = Impression.last_week_followed_back(current_user, params[:week])
	end

	def update_info
		acc = current_user.account

		if !acc
			acc = Account.new({:user_id => current_user.id, :uid => current_user.uid, :plan_id => Plan.first.id, :start_date => Time.now, :end_date => 1.month.from_now})
			acc.email = params[:account][:email]
			acc.save
		elsif acc and acc.email != params[:account][:email]
			acc.update_attribute(:email, params[:account][:email])
		end
		respond_to do |format|
			format.js {render :js => "$('#myModal1').modal('hide')"}
		end
	end

	def account
		@plans = Plan.all
		@payments = []
		@plans[1..(@plans.size-1)].each do |plan|
	    	@payments << Payment.digital.popup.recurring.build({:amount => plan.price, :plan_id => plan.id, :identifier => "#{rand(1000000000000000)}"})
	    	# Rails.logger.info "@@@ #{@payments.last.inspect}"
	    end

		render "campaigns", :formats => [:html]
	end
end
