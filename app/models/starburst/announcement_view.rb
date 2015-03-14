module Starburst
	class AnnouncementView < ActiveRecord::Base
		if Rails::VERSION::MAJOR < 4
			attr_accessible :announcement_id, :user_id
		end
		
		belongs_to :announcement
		belongs_to :user

		validates :announcement_id, presence: true
		validates :user_id, presence: true
		validates_uniqueness_of :user_id, scope: :announcement_id
	end
end