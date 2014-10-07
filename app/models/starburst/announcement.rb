module Starburst
	class Announcement < ActiveRecord::Base
		serialize :limit_to_users

		if Rails::VERSION::MAJOR < 4
			attr_accessible(:title, :body, :start_delivering_at, :stop_delivering_at, :limit_to_users)
		end

		scope :ready_for_delivery, lambda { 
			where("(start_delivering_at < ? OR start_delivering_at IS NULL) 
				AND (stop_delivering_at > ? OR stop_delivering_at IS NULL)", Time.now, Time.now) 
		}

		scope :unread_by, lambda {|current_user|
			joins("LEFT JOIN starburst_announcement_views ON 
				starburst_announcement_views.announcement_id = starburst_announcements.id AND 
				starburst_announcement_views.user_id = #{Announcement.sanitize(current_user.id)}")
			.where("starburst_announcement_views.announcement_id IS NULL AND starburst_announcement_views.user_id IS NULL")
		}

		scope :in_delivery_order, lambda { order("start_delivering_at ASC")}

		def self.current(current_user = nil)
			if current_user
				find_announcement_for_current_user(ready_for_delivery.unread_by(current_user).in_delivery_order, current_user)
			else
				ready_for_delivery.in_delivery_order.first
			end
		end

		def self.find_announcement_for_current_user(announcements, user)
			user_as_array = user.serializable_hash(methods: Starburst.user_instance_methods)
			announcements.each do |announcement|
				if user_matches_conditions(user_as_array, announcement.limit_to_users)
					return announcement
				end
			end
			return nil
		end

		def self.user_matches_conditions(user, conditions = nil)
			if conditions
				conditions.each do |condition|
					if user[condition[:field]] != condition[:value]
						return false
					end
				end
			end
			return true
		end

	end
end
