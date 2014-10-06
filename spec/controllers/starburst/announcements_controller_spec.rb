require 'spec_helper'

module Starburst

	describe AnnouncementsController do
		
		routes { Starburst::Engine.routes } # http://pivotallabs.com/writing-rails-engine-rspec-controller-tests/

		it "marks an announcement as read" do
			@current_user = mock_model(User, :id => 10)
			controller.stub(:current_user).and_return(@current_user)
			announcement = FactoryGirl.create(:announcement)
			post :mark_as_read, :id => announcement.id
			expect(response.status).to eq 200
			expect(AnnouncementView.last.user_id).to eq 10
			expect(AnnouncementView.all.length).to eq 1
		end
		it "does not mark an announcement as read if no one is logged in" do
			#@current_user = mock_model(User, :id => 10)
			controller.stub(:current_user).and_return(nil)
			announcement = FactoryGirl.create(:announcement)
			post :mark_as_read, :id => announcement.id
			expect(response.status).to eq 422
			expect(AnnouncementView.all.length).to eq 0
		end
		it "has a helper path for mark as read" do
			expect(mark_as_read_path(1)).to eq "/starburst/announcements/1/mark_as_read"
		end
	end

end