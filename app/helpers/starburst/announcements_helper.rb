module Starburst
  module AnnouncementsHelper
  	def current_announcement
		if (defined? current_user) && current_user
    		@current_announcement ||= Announcement.current(current_user)
		else
			false
		end
  	end
  end
end
