require 'spec_helper'

module Starburst

	describe AnnouncementsController, type: :controller do

		routes { Starburst::Engine.routes } # http://pivotallabs.com/writing-rails-engine-rspec-controller-tests/

		it "marks an announcement as read (twice)" do
			current_user = instance_double(User, id: 10)
			controller.stub(:current_user).and_return(current_user)
			announcement = FactoryGirl.create(:announcement)
			announcement2 = FactoryGirl.create(:announcement)
			if Rails::VERSION::MAJOR < 5
				post :mark_as_read, id: announcement.id
			else
				post :mark_as_read, params: { id: announcement.id }
			end
			expect(response.status).to eq 200
			expect(AnnouncementView.last.user_id).to eq 10
			expect(AnnouncementView.all.length).to eq 1
			if Rails::VERSION::MAJOR < 5
				post :mark_as_read, id: announcement2.id
			else
				post :mark_as_read, params: { id: announcement2.id }
			end
			expect(response.status).to eq 200
			expect(AnnouncementView.last.user_id).to eq 10
			expect(AnnouncementView.all.length).to eq 2
		end

		it "does not mark an announcement as read if no one is logged in" do
			controller.stub(:current_user).and_return(nil)
			announcement = FactoryGirl.create(:announcement)
			if Rails::VERSION::MAJOR < 5
				post :mark_as_read, id: announcement.id
			else
				post :mark_as_read, params: { id: announcement.id }
			end
			expect(response.status).to eq 422
			expect(AnnouncementView.all.length).to eq 0
		end

		it "has a helper path for mark as read" do
			expect(mark_as_read_path(1)).to eq "/starburst/announcements/1/mark_as_read"
		end

	end

end
