require "starburst/engine"
require "helpers/configuration"

module Starburst
	extend Configuration

	define_setting :current_user_class, "current_user"
	define_setting :user_instance_methods
end
