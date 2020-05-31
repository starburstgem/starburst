# frozen_string_literal: true

RSpec.describe 'Announcements' do
  let!(:announcement) { create(:announcement) }

  context 'when the user is signed in' do
    let(:current_user) { create(:user) }

    before { visit root_path(user_id: current_user.id) }

    it 'displays the current announcement' do
      expect(page).to have_content('Sample homepage')
      expect(page).to have_content(announcement.body)
    end

    it 'hides the announcement if the user closes it', js: true, driver: :selenium_chrome_headless do
      expect(page).to have_content(announcement.body)
      find('#starburst-close').click
      expect(page).not_to have_content(announcement.body)
    end
  end

  context 'when the user is not signed in' do
    before { visit root_path }

    it 'does not display the current announcement' do
      expect(page).to have_content('Sample homepage')
      expect(page).not_to have_content(announcement.body)
    end
  end
end
