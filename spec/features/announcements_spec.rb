# frozen_string_literal: true

RSpec.describe 'Announcements' do
  let!(:announcement) { create(:announcement) }

  context 'when the User is signed in' do
    let(:current_user) { create(:user) }

    before { visit root_path(user_id: current_user.id) }

    it 'displays the current Announcement' do
      expect(page).to have_content('Sample homepage')
      expect(page).to have_content(announcement.body)
    end

    skip 'hides the Announcement if the User closes it', js: true, driver: :selenium_chrome_headless do
      expect(page).to have_content(announcement.body)
      find('#starburst-close').click
      expect(page).not_to have_content(announcement.body)
    end
  end

  context 'when the User is not signed in' do
    before { visit root_path }

    it 'does not display the current Announcement' do
      expect(page).to have_content('Sample homepage')
      expect(page).not_to have_content(announcement.body)
    end
  end
end
