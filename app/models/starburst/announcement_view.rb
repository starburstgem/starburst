module Starburst
	class AnnouncementView < ActiveRecord::Base
		if Rails::VERSION::MAJOR < 4
			attr_accessible :announcement, :user
		end
		belongs_to :announcement
		belongs_to :user
	end
end