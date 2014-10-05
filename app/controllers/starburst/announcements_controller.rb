module Starburst
	class AnnouncementsController < ApplicationController
		def mark_as_read
			if current_user and Announcement.find(params[:id].to_i)
				AnnouncementView.create!(:user => current_user, :announcement => Announcement.find(params[:id].to_i))
			end
			render :json => :ok
		end
	end
end