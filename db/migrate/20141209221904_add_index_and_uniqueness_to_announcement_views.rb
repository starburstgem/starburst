# frozen_string_literal: true

class AddIndexAndUniquenessToAnnouncementViews < ActiveRecord::Migration[4.2]
  def change
    add_index(
      :starburst_announcement_views,
      %i[user_id announcement_id],
      unique: true,
      name: 'starburst_announcement_view_index'
    )
  end
end
