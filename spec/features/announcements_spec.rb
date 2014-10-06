require 'spec_helper'

feature 'Announcements' do
	scenario 'show announcement to user' do
		@current_user = FactoryGirl.create(:user)
		ActionView::Base.any_instance.stub(:current_user).and_return(@current_user)
		announcement = FactoryGirl.create(:announcement, :body => "My announcement")
		visit root_path
		page.should have_content "My announcement"
	end
end