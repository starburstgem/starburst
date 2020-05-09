### 2.0.0 (Unreleased)

* Drops support for Rails versions 3.0, 3.1, 3.2, 4.0 and 4.1.
* Adds support for Rails versions 4.2, 5.0, 5.1, 5.2 and 6.0.
* Adds support for changing the base controller which `Starburst::AnnouncementsController` inherits from.
* Removed `Configuration` module.
* `Starburst.current_user_method` now defaults to a symbol value.
* `Starburst.user_instance_methods` now defaults to an empty array.
* Include private and protected methods when searching for `Starburst.current_user_method`.

### 1.0.3

* Fixes the "mark as read" issue.

### 1.0.2

* Adds support for methods other than `current_user`.

### 1.0.1

* Fixes critical issue where announcements past the first cannot be marked as read. No breaking changes.

### 1.0.0

* First release.
