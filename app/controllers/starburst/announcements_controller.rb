module Starburst
	class AnnouncementsController < ApplicationController
		def mark_as_read
			announcement = Announcement.find(params[:id].to_i)
			if respond_to?(Starburst.current_user_class) && send(Starburst.current_user_class) && announcement
				if AnnouncementView.create(:user => send(Starburst.current_user_class), :announcement => announcement)
					render :json => :ok
				else
					render json: nil, :status => :unprocessable_entity
				end
			else
					render json: nil, :status => :unprocessable_entity
			end
		end
	end
end