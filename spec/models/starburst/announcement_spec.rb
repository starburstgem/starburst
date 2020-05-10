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

  describe '.unread_by' do
    subject { described_class.unread_by(current_user) }

    let(:current_user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:announcement1) { create(:announcement) }
    let(:announcement2) { create(:announcement) }

    before do
      create(:announcement_view, user: another_user, announcement: announcement1)
      create(:announcement_view, user: current_user, announcement: announcement2)
    end

    it { is_expected.to contain_exactly(announcement1) }
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
