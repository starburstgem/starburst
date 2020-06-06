# frozen_string_literal: true

RSpec.describe 'Announcements' do
  shared_examples 'announcement display' do
    let!(:announcement) { create(:announcement) }
    let(:user_id) { current_user.try(:id) }

    before { visit announcement_page }

    context 'when the user is signed in' do
      let(:current_user) { create(:user) }

      it 'displays the current announcement' do
        expect(page).to have_content(title)
        expect(page).to have_content(announcement.body)
      end

      it 'hides the announcement if the user closes it', js: true, driver: :selenium_chrome_headless do
        expect(page).to have_content(announcement.body)
        find('#starburst-close').click
        expect(page).not_to have_content(announcement.body)
      end
    end

    shared_examples 'when the user is not signed in' do
      let(:current_user) { nil }

      it 'does not display the current announcement' do
        expect(page).to have_content(title)
        expect(page).not_to have_content(announcement.body)
      end
    end
  end

  context 'with a Bootstrap layout' do
    let(:announcement_page) { bootstrap_path(user_id: user_id) }
    let(:title) { 'Bootstrap Announcement' }

    include_examples 'announcement display'
  end

  context 'with a Custom layout' do
    let(:announcement_page) { custom_path(user_id: user_id) }
    let(:title) { 'Custom Announcement' }

    include_examples 'announcement display'
  end

  context 'with a Foundation layout' do
    let(:announcement_page) { foundation_path(user_id: user_id) }
    let(:title) { 'Foundation Announcement' }

    include_examples 'announcement display'
  end
end
