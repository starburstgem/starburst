require_relative "../../spec_helper"

module Starburst

describe Announcement do

  context "a basic announcement" do

    it "mock test" do
      user = User.new
      puts "id is " + user.id.to_s
    end

    it "can be created with just a body" do
      expect(Announcement.create(:body => "This is an announcement.")).to be_valid
    end

    it "can be created with just a title" do
      expect(Announcement.create(:body => "This is an announcement.", :title => "Test title")).to be_valid
    end

  end

  context "a scheduled annoucement" do

    it "does not show up past its end date" do
      Announcement.create(:stop_delivering_at => 1.day.ago)
      expect(Announcement.current.blank?).to eq true
    end

    it "shows before its end date" do
      Announcement.create(:stop_delivering_at => Date.today + 1.day)
      expect(Announcement.current.present?).to eq true
    end

    it "does not show up before its start date" do
      Announcement.create(:start_delivering_at => Date.today + 1.day)
      expect(Announcement.current.blank?).to eq true
    end

    it "shows after its start date" do
      Announcement.create(:start_delivering_at => 1.day.ago)
      expect(Announcement.current.present?).to eq true
    end

    it "shows up between its start and end dates" do
      Announcement.create(:start_delivering_at => Date.today, :stop_delivering_at => Date.today + 1)
      expect(Announcement.current.present?).to eq true
    end

    it "does not show when its start and end dates are the same" do
      Announcement.create(:start_delivering_at => Date.today, :stop_delivering_at => Date.today)
      expect(Announcement.current.blank?).to eq true
    end

    it "does not show when its start and end dates are the same" do
      Announcement.create(:start_delivering_at => Date.today, :stop_delivering_at => Date.today)
      expect(Announcement.current.blank?).to eq true
    end

  end

  context "an announcement not yet read by the current user" do

    it "shows up" do
      read_announcement = Announcement.create(:start_delivering_at => 1.day.ago)
      unread_announcement = Announcement.create(:start_delivering_at => Date.today)
      user_who_read_announcement = create(:user)
      AnnouncementView.create(:announcement => read_announcement, :user => user_who_read_announcement)
      expect(Announcement.unread_by(user_who_read_announcement)).to eq [unread_announcement]
    end

    it "shows up for the current user even when others have read it" do
      read_announcement = Announcement.create(:start_delivering_at => 1.day.ago)
      unread_announcement = Announcement.create(:start_delivering_at => Date.today)
      user_who_read_announcement = create(:user)
      user_who_read_no_announcements = create(:user)
      AnnouncementView.create(:announcement => read_announcement, :user => user_who_read_announcement)
      expect(Announcement.unread_by(user_who_read_no_announcements)).to include(unread_announcement, read_announcement)
    end

    it "shows up for the current user even when they have read other announcements" do
      read_announcement = Announcement.create(:start_delivering_at => 1.day.ago)
      unread_announcement = Announcement.create(:start_delivering_at => Date.today)
      user_who_read_announcement = create(:user)
      AnnouncementView.create(:announcement => read_announcement, :user => user_who_read_announcement)
      expect(Announcement.current(user_who_read_announcement)).to eq unread_announcement
    end
    
  end

  context "an announcement targeted to certain users" do
    it "has a limited_to_users field that is retrieveable from the database" do
      limited_announcement = Announcement.create(:limit_to_users => [
        {
          :field => "subscription",
          :value => "",
          :operator => "="
        }
      ])
      expect(limited_announcement.limit_to_users[0][:field]).to eq "subscription"
    end

    it "shows up for the proper user only (one positive condition)" do
      limited_announcement = Announcement.create(:limit_to_users => [
        {
          :field => "subscription",
          :value => ""
        }
      ])
      user_who_should_see_announcement = create(:user, :subscription => "")
      user_who_should_not_see_announcement = create(:user, :subscription => "monthly")
      expect(Announcement.find_announcement_for_current_user(Announcement.scoped, user_who_should_see_announcement)).to eq limited_announcement
      expect(Announcement.find_announcement_for_current_user(Announcement.scoped, user_who_should_not_see_announcement)).to eq nil
    end

    it "shows up for the proper user only (method condition)" do
      limited_announcement = Announcement.create(:limit_to_users => [
        {
          :field => "free?",
          :value => true
        }
      ])
      user_who_should_see_announcement = create(:user, :subscription => "")
      user_who_should_not_see_announcement = create(:user, :subscription => "monthly")
      expect(Announcement.find_announcement_for_current_user(Announcement.scoped, user_who_should_see_announcement)).to eq limited_announcement
      expect(Announcement.find_announcement_for_current_user(Announcement.scoped, user_who_should_not_see_announcement)).to eq nil
    end

    # it "performs" do
    #   pending
    #   require 'benchmark'
      
    #   (1 .. 500).each do
    #     Announcement.create(:limit_to_users => [
    #       {
    #         :field => "subscription",
    #         :value => ""
    #       }
    #     ])
    #   end

    #   (1 .. 10000).each do
    #     create(:user, :subscription => "")
    #   end

    #   Benchmark.realtime{
    #   Announcement.current(User.last)
    #   }
    # end

  end



end

end
