class Plan < ActiveRecord::Base
  attr_accessible :price, :summary, :title, :monthly_impressions
end
