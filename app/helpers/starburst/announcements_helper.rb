module Starburst
  module AnnouncementsHelper
  	def current_announcement
		if defined? current_user
    		@current_announcement ||= Announcement.current(current_user)
		else
			nil
		end
  	end
  end
end
