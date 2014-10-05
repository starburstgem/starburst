class User < ActiveRecord::Base
	def free?
		subscription.blank?
	end
end
