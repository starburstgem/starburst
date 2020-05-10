# frozen_string_literal: true

RSpec.describe Starburst::Announcement do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:body) }
  end

  describe '.current' do
    subject { described_class.current(user) }

    let(:user) { create(:user) }

    shared_examples 'oldest unread announcement' do
      it { is_expected.to eq(first_announcement) }

      context 'when a previous announcement has already been seen' do
        before { create(:announcement_view, user: user, announcement: first_announcement) }

        it { is_expected.to eq(second_announcement) }
      end
    end

    context 'when it is expired' do
      before { create(:announcement, stop_delivering_at: 1.minute.ago) }

      it { is_expected.to be_nil }
    end

    context 'when it is not expired yet' do
      let!(:first_announcement) { create(:announcement, start_delivering_at: 2.minutes.ago, stop_delivering_at: 10.minutes.from_now) }
      let!(:second_announcement) { create(:announcement, start_delivering_at: 1.minute.ago, stop_delivering_at: 10.minutes.from_now) }

      include_examples 'oldest unread announcement'
    end

    context 'when it is due' do
      let!(:first_announcement) { create(:announcement, start_delivering_at: 2.minutes.ago) }
      let!(:second_announcement) { create(:announcement, start_delivering_at: 1.minute.ago) }

      include_examples 'oldest unread announcement'
    end

    context 'when it is not due yet' do
      before { create(:announcement, start_delivering_at: 1.minute.from_now) }

      it { is_expected.to be_nil }
    end

    context 'when no timestamps are set' do
      let!(:first_announcement) { create(:announcement, start_delivering_at: nil, stop_delivering_at: nil) }
      let!(:second_announcement) { create(:announcement, start_delivering_at: nil, stop_delivering_at: nil) }

      include_examples 'oldest unread announcement'
    end

    context 'when there are announcements with an attribute condition' do
      let!(:first_announcement) do
        create(
          :announcement,
          start_delivering_at: 2.minutes.ago,
          limit_to_users: [
            {
              field: 'subscription',
              value: 'weekly'
            }
          ]
        )
      end
      let!(:second_announcement) do
        create(
          :announcement,
          start_delivering_at: 1.minutes.ago,
          limit_to_users: [
            {
              field: 'subscription',
              value: 'weekly'
            }
          ]
        )
      end

      context 'when the user should see the announcements' do
        let(:user) { create(:user, subscription: 'weekly') }

        include_examples 'oldest unread announcement'
      end

      context 'when the user should not see the announcements' do
        let(:user) { create(:user, subscription: 'monthly') }

        it { is_expected.to be_nil }
      end
    end

    context 'when there are announcements with a method condition' do
      let!(:first_announcement) do
        create(
          :announcement,
          start_delivering_at: 2.minutes.ago,
          limit_to_users: [
            {
              field: 'free?',
              value: true
            }
          ]
        )
      end
      let!(:second_announcement) do
        create(
          :announcement,
          start_delivering_at: 1.minute.ago,
          limit_to_users: [
            {
              field: 'free?',
              value: true
            }
          ]
        )
      end

      before { allow(Starburst).to receive(:user_instance_methods).and_return(%i[free?]) }

      context 'when the user should see the announcement' do
        let(:user) { create(:user, subscription: '') }

        include_examples 'oldest unread announcement'
      end

      context 'when the user should not see the announcement' do
        let(:user) { create(:user, subscription: 'monthly') }

        it { is_expected.to be_nil }
      end
    end
  end

  describe '.ready_for_delivery' do
    subject { described_class.ready_for_delivery }

    let!(:due_announcement) { create(:announcement, start_delivering_at: 1.minute.ago) }
    let!(:not_due_announcement) { create(:announcement, start_delivering_at: 1.minute.from_now) }
    let!(:expired_announcement) { create(:announcement, stop_delivering_at: 1.minute.ago) }
    let!(:not_expired_announcement) { create(:announcement, stop_delivering_at: 1.minute.from_now) }
    let!(:unscheduled_announcement) { create(:announcement, start_delivering_at: nil, stop_delivering_at: nil) }

    it { is_expected.to contain_exactly(due_announcement, not_expired_announcement, unscheduled_announcement) }
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

  describe '.find_announcement_for_current_user' do
    subject { described_class.find_announcement_for_current_user(described_class.all, user) }

    context 'with an attribute condition' do
      let!(:announcement) do
        create(
          :announcement,
          limit_to_users: [
            {
              field: 'subscription',
              value: 'weekly'
            }
          ]
        )
      end

      context 'when the user should see the announcement' do
        let(:user) { create(:user, subscription: 'weekly') }

        it { is_expected.to eq(announcement) }
      end

      context 'when the user should not see the announcement' do
        let(:user) { create(:user, subscription: 'monthly') }

        it { is_expected.to be_nil }
      end
    end

    context 'with a method condition' do
      let!(:announcement) do
        create(
          :announcement,
          limit_to_users: [
            {
              field: 'free?',
              value: true
            }
          ]
        )
      end

      before { allow(Starburst).to receive(:user_instance_methods).and_return(%i[free?]) }

      context 'when the user should see the announcement' do
        let(:user) { create(:user, subscription: '') }

        it { is_expected.to eq(announcement) }
      end

      context 'when the user should not see the announcement' do
        let(:user) { create(:user, subscription: 'monthly') }

        it { is_expected.to be_nil }
      end
    end
  end
end
