module Starburst
	class AnnouncementsController < ApplicationController
		def mark_as_read
			if current_user and Announcement.find(params[:id].to_i)
				if AnnouncementView.create(:user => current_user, :announcement => Announcement.find(params[:id].to_i))
					render :json => :ok
					return
				end
			end
			render json: nil, :status => :unprocessable_entity
		end
	end
end