class ApplicationController < ActionController::Base
  	protect_from_forgery
  	before_filter :login_required

  	helper_method :current_user

  	def login_required
  		redirect_to root_url if !current_user
  	end

  	################################################################
	private

	def current_user
	  @current_user ||= User.includes(account: [:plan, :payment] ).find(session[:user_id]) if session[:user_id]
	end
end
