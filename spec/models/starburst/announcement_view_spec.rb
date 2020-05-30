# frozen_string_literal: true

RSpec.describe Starburst::AnnouncementView do
  describe 'relationships' do
    it { is_expected.to belong_to(:announcement) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:announcement_id) }
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:announcement_id) } # TODO: invert this
  end
end
