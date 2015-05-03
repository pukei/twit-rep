module ApplicationHelper
	def plan_message(u)
		begin
			case u.account.plan.title
			when 'Free'
				"Plan start date <b>#{current_user.account.start_date}</b>."
			else
				"Plan start date <b>#{current_user.account.start_date}</b>."
			end
		rescue
			""
		end
	end
end
