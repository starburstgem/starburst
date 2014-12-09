require 'spec_helper'

feature 'Announcements' do
	scenario 'show announcement to user' do
		@current_user = FactoryGirl.create(:user)
		ActionController::Base.any_instance.stub(:current_user).and_return(@current_user)
		ActionView::Base.any_instance.stub(:current_user).and_return(@current_user)
		FactoryGirl.create(:announcement, :body => "My announcement")
		visit root_path
		page.should have_content "My announcement"
	end
	scenario 'show no announcements if user not logged in' do
		ActionController::Base.any_instance.stub(:current_user).and_return(nil)
		ActionView::Base.any_instance.stub(:current_user).and_return(nil)
		FactoryGirl.create(:announcement, :body => "My announcement")
		visit root_path
		page.should_not have_content "My announcement"
		page.should have_content "Sample homepage"
	end
	scenario 'stop showing announcement once the user has read it' do
		@current_user = FactoryGirl.create(:user)
		ActionController::Base.any_instance.stub(:current_user).and_return(@current_user)
		ActionView::Base.any_instance.stub(:current_user).and_return(@current_user)
		announcement = FactoryGirl.create(:announcement, :body => "My announcement")
		visit root_path
		page.should have_content "My announcement"
		FactoryGirl.create(:announcement_view, :user => @current_user, :announcement => announcement)
		visit root_path
		page.should_not have_content "My announcement"
	end
	scenario 'allow the user to click to hide the announcement' do
		pending "Figure out how to best stub the current_user method for a JavaScript-enabled test"
	end
end
