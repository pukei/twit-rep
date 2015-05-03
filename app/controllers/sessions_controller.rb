class SessionsController < ApplicationController
	skip_filter :login_required#, :only => [:create]

	def create
	  auth = request.env["omniauth.auth"]
	  # Rails.logger.info "@@@ #{auth.inspect}"
	  # Rails.logger.info "@@@ #{request.inspect}"
	  user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
	  
	  if user
	  	user.verify_user_details(auth)
	  	session[:user_id] = user.id

	  	redirect_to campaigns_users_url
	  else
	  	redirect_to root_url, :notice => "Signed in!"
	  end
	end

	def destroy
	  session[:user_id] = nil
	  redirect_to root_url, :notice => "Signed out!"
	end
end
