module Starburst
	class AnnouncementView < ActiveRecord::Base
		#attr_accessible :announcement, :user
		belongs_to :announcement
		belongs_to :user
	end
end