Starburst::Engine.routes.draw do
	post "announcements/:id/mark_as_read", to: "announcements#mark_as_read"
end
