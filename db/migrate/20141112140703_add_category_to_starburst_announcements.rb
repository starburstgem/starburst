class AddCategoryToStarburstAnnouncements < ActiveRecord::Migration
  def change
    add_column :starburst_announcements, :category, :text
  end
end
