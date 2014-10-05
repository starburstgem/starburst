module Starburst
	class AnnouncementsController < ApplicationController
		def mark_as_read
			announcement = Announcement.find(params[:id].to_i)
			if current_user && announcement
				if AnnouncementView.create(:user => current_user, :announcement => announcement)
					render :json => :ok
					return
				end
			end
			render json: nil, :status => :unprocessable_entity
		end
	end
end