module Starburst
  module AnnouncementsHelper

    def current_announcement
      if (defined? Starburst.current_user_method) && send(Starburst.current_user_method)
        @current_announcement ||= Announcement.current(send(Starburst.current_user_method))
      else
        false
      end
    end

  end
end
