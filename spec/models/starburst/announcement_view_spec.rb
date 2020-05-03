require_relative "../../spec_helper"

module Starburst

describe AnnouncementView do

  it "does not allow a user to mark two views of an announcement" do
  	user = create(:user)
  	announcement = create(:announcement)
  	view1 = create(:announcement_view, :user => user, :announcement => announcement)
  	view2 = build(:announcement_view, :user => user, :announcement => announcement)
  	expect(view1).to be_valid
  	expect(view2.tap(&:valid?).errors[:user_id]).not_to be_empty
  end

  it "allows a user to log views of different announcements" do
  	user = create(:user)
  	announcement1 = create(:announcement)
  	announcement2 = create(:announcement)
  	view1 = create(:announcement_view, :user => user, :announcement => announcement1)
  	view2 = create(:announcement_view, :user => user, :announcement => announcement2)
  	expect(view1).to be_valid
  	expect(view2).to be_valid
  end

  it "allows multiple users to view the same announcement" do
  	user1 = create(:user)
  	user2 = create(:user)
  	announcement = create(:announcement)
  	view1 = create(:announcement_view, :user => user1, :announcement => announcement)
  	view2 = create(:announcement_view, :user => user2, :announcement => announcement)
  	expect(view1).to be_valid
  	expect(view2).to be_valid
  end

end
end
