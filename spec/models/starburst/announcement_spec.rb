# frozen_string_literal: true

RSpec.describe Starburst::Announcement do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:body) }
  end

  describe '.current' do
    subject { described_class.current }

    context 'when it is expired' do
      before { create(:announcement, stop_delivering_at: 1.minute.ago) }

      it { is_expected.to be_blank }
    end

    context 'when it is not expired' do
      before { create(:announcement, stop_delivering_at: 1.minute.from_now) }

      it { is_expected.to be_present }
    end

    context 'when is due' do
      before { create(:announcement, start_delivering_at: 1.minute.ago) }

      it { is_expected.to be_present }
    end

    context 'when it is not due yet' do
      before { create(:announcement, start_delivering_at: 1.minute.from_now) }

      it { is_expected.to be_blank }
    end

    context 'when no timestamps are set' do
      before { create(:announcement, start_delivering_at: nil, stop_delivering_at: nil) }

      it { is_expected.to be_present }
    end
  end

  context "an announcement not yet read by the current user" do

    it "shows up" do
      read_announcement = Announcement.create(:body => "test", :start_delivering_at => 1.day.ago)
      unread_announcement = Announcement.create(:body => "test", :start_delivering_at => Time.current)
      user_who_read_announcement = create(:user)
      AnnouncementView.create(:announcement => read_announcement, :user => user_who_read_announcement)
      expect(Announcement.unread_by(user_who_read_announcement)).to eq [unread_announcement]
    end

    it "shows up for the current user even when others have read it" do
      read_announcement = Announcement.create(:body => "test", :start_delivering_at => 1.day.ago)
      unread_announcement = Announcement.create(:body => "test", :start_delivering_at => Time.current)
      user_who_read_announcement = create(:user)
      user_who_read_no_announcements = create(:user)
      AnnouncementView.create(:announcement => read_announcement, :user => user_who_read_announcement)
      expect(Announcement.unread_by(user_who_read_no_announcements)).to include(unread_announcement, read_announcement)
    end

  it "shows up for the current user even when they have read other announcements" do
      read_announcement = Announcement.create(:body => "test", :start_delivering_at => 1.day.ago)
      unread_announcement = Announcement.create(:body => "test", :start_delivering_at => Time.current)
      user_who_read_announcement = create(:user)
      AnnouncementView.create(:announcement => read_announcement, :user => user_who_read_announcement)
      expect(Starburst::Announcement.current(user_who_read_announcement)).to eq unread_announcement
    end


  end

  context "an announcement targeted to certain users" do
    it "has a limited_to_users field that is retrieveable from the database" do
      limited_announcement = Announcement.create(:body => "test", :limit_to_users => [
        {
          :field => "subscription",
          :value => "",
          :operator => "="
        }
      ])
      expect(limited_announcement.limit_to_users[0][:field]).to eq "subscription"
    end

    it "shows up for the proper user only (one positive condition)" do
      limited_announcement = Announcement.create(:body => "test", :limit_to_users => [
        {
          :field => "subscription",
          :value => ""
        }
      ])
      user_who_should_see_announcement = create(:user, :subscription => "")
      user_who_should_not_see_announcement = create(:user, :subscription => "monthly")
      expect(Announcement.find_announcement_for_current_user(Announcement.where(nil), user_who_should_see_announcement)).to eq limited_announcement
      expect(Announcement.find_announcement_for_current_user(Announcement.where(nil), user_who_should_not_see_announcement)).to eq nil
    end

    it "shows up for the proper user only (method condition)" do
      allow(Starburst).to receive(:user_instance_methods).and_return(%i[free?])
      limited_announcement = Announcement.create(:body => "test", :limit_to_users => [
        {
          :field => "free?",
          :value => true
        }
      ])
      user_who_should_see_announcement = create(:user, :subscription => "")
      user_who_should_not_see_announcement = create(:user, :subscription => "monthly")
      expect(Announcement.find_announcement_for_current_user(Announcement.where(nil), user_who_should_see_announcement)).to eq limited_announcement
      expect(Announcement.find_announcement_for_current_user(Announcement.where(nil), user_who_should_not_see_announcement)).to eq nil
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
