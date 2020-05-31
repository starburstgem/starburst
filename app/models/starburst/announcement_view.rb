module Starburst
	class AnnouncementView < ActiveRecord::Base
		belongs_to :announcement
		belongs_to :user

		validates :announcement_id, presence: true
		validates :user_id, presence: true
		validates_uniqueness_of :user_id, scope: :announcement_id
	end
end
