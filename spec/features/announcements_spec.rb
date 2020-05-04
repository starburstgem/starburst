require 'spec_helper'

feature 'Announcements' do
	scenario 'show announcement to user' do
		@current_user = create(:user)
		create(:announcement, :body => "My announcement")
		visit root_path(user_id: @current_user.id)
		page.should have_content "My announcement"
	end
	scenario 'show no announcements if user not logged in' do
		create(:announcement, :body => "My announcement")
		visit root_path
		page.should_not have_content "My announcement"
		page.should have_content "Sample homepage"
	end
	scenario 'stop showing announcement once the user has read it' do
		@current_user = create(:user)
		announcement = create(:announcement, :body => "My announcement")
		visit root_path(user_id: @current_user.id)
		page.should have_content "My announcement"
		create(:announcement_view, :user => @current_user, :announcement => announcement)
		visit root_path(user_id: @current_user.id)
		page.should_not have_content "My announcement"
	end
	scenario 'allow the user to click to hide the announcement' do
		skip "Figure out how to best stub the current_user method for a JavaScript-enabled test"
	end
end
