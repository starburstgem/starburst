# frozen_string_literal: true

class AddCategoryToStarburstAnnouncements < ActiveRecord::Migration[4.2]
  def change
    add_column :starburst_announcements, :category, :text
  end
end
