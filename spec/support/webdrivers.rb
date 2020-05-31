# frozen_string_literal: true

# Fixes Webdrivers gem warning for older versions.
Webdrivers.cache_time = 10.minutes if Webdrivers.cache_time.zero?
