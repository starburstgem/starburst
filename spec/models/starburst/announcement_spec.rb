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
