require_relative "../../spec_helper"

module Starburst

describe AnnouncementView do

  it "does not allow a user to mark two views of an announcement" do
  	user = FactoryGirl.create(:user)
  	announcement = FactoryGirl.create(:announcement)
  	view1 = FactoryGirl.create(:announcement_view, :user => user, :announcement => announcement)
  	view2 = FactoryGirl.build(:announcement_view, :user => user, :announcement => announcement)
  	expect(view1).to be_valid
  	expect(view2).to have(1).error_on(:user_id)
  end

  it "allows a user to log views of different announcements" do
  	user = FactoryGirl.create(:user)
  	announcement1 = FactoryGirl.create(:announcement)
  	announcement2 = FactoryGirl.create(:announcement)
  	view1 = FactoryGirl.create(:announcement_view, :user => user, :announcement => announcement1)
  	view2 = FactoryGirl.create(:announcement_view, :user => user, :announcement => announcement2)
  	expect(view1).to be_valid
  	expect(view2).to be_valid
  end

  it "allows multiple users to view the same announcement" do
  	user1 = FactoryGirl.create(:user)
  	user2 = FactoryGirl.create(:user)
  	announcement = FactoryGirl.create(:announcement)
  	view1 = FactoryGirl.create(:announcement_view, :user => user1, :announcement => announcement)
  	view2 = FactoryGirl.create(:announcement_view, :user => user2, :announcement => announcement)
  	expect(view1).to be_valid
  	expect(view2).to be_valid
  end

end
end