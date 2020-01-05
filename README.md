# Starburst

[![Build Status](https://travis-ci.org/starburstgem/starburst.svg?branch=master)](https://travis-ci.org/starburstgem/starburst)
[![Maintainability](https://api.codeclimate.com/v1/badges/7f5df24aaefecbd270b4/maintainability)](https://codeclimate.com/github/starburstgem/starburst/maintainability)

Starburst allows you to show messages to logged in users within your Rails app. Once the user closes the message, they won't see it again.

You can target messages to particular groups of users, based on their database attributes or your own methods on the User class. For instance, you might send a message only to users on your premium plan.

Starburst remembers _on the server_ who has closed which message. Therefore, a user who closes a message on their desktop won't see it again on their mobile device. Starburst doesn't use cookies, so a user won't see an announcement they've already read if they switch devices or clear their cookies.

Starburst is in production on <a href="http://www.cooksmarts.com/">Cook Smarts</a>, where it has served announcements to thousands of users.

[![Announcement in Zurb Foundation](http://aspiringwebdev.com/wp-content/uploads/2014/10/starburst-foundation.png)](#)

_An announcement delivered by Starburst, on a Rails app using Zurb Foundation_

## Use cases

Use Starburst to share announcements with your users, like:

- A new feature
- Upcoming downtime
- A coupon to upgrade to a premium plan

Users will see the message until they dismiss it, and then won't see it again.

A user will not see the next announcement until they acknowledge the previous one (i.e. users are shown one announcement at a time). Announcements are delivered earliest first. Be sure to [schedule](#scheduling) announcements so they appear only while they're relevant.

## Requirements

### Authentication
Starburst needs to know who is logged in to your app. If you are using Devise, Clearance, or another authentication library that sets a current\_user method, you're all set.

If you use a different authentication system that does not set a current\_user method, [tell Starburst](#current_user) what method your library uses.

### Ruby and Rails

Starburst [works](https://secure.travis-ci.org/csm123/starburst) on Rails 4.2, 5.0, 5.1, 5.2, and 6.0. It should work with the same Ruby versions supported by each framework version.

## Installation

Add Starburst to your gemfile:

```ruby
gem "starburst"
```

Run the following commands:

```
rake starburst:install:migrations
rake db:migrate
```

Add the following line to your ApplicationController (app/controllers/starburst/application_controller.rb):

```ruby
helper Starburst::AnnouncementsHelper
```

Add the following line to your routes file (config/routes.rb):

```ruby
mount Starburst::Engine => "/starburst"
```

Add the following line to your application.js file (app/assets/javascripts/application.js):

```
//= require starburst/starburst
```

## Getting started

### Add an announcement partial to your app's layout

Starburst comes with pre-built announcement boxes for sites using Zurb Foundation and Twitter Bootstrap. It also includes an announcement box with no assigned styles.

Add one of the lines below your application layout view at `app/views/layouts/application.html.erb`, right above `<%= yield =>`. You can place the partials anywhere, of course; this is just the most common location.

#### Twitter Bootstrap

```erb
<%= render :partial => "announcements/starburst/announcement_bootstrap" %>
```

#### Zurb Foundation

```erb
<%= render :partial => "announcements/starburst/announcement_foundation" %>
```

#### Custom styles

```erb
<%= render :partial => "announcements/starburst/announcement" %>
```

Set your own styles. Use `#starburst-announcement` ID for the box, and the `#starburst-close` for the close button.

### Add an announcement

Starburst doesn't have an admin interface yet, but you can add announcements through your own code.

```ruby
Starburst::Announcement.create(:body => "Our app now features lots of balloons! Enjoy!")
```

This will present an announcement to every user of the app. Once they dismiss the announcement, they won't see it again.

Find out more about [scheduling announcements](#scheduling) and [targeting them to specific users](#targeting).

<a name="scheduling"></a>
## Scheduling announcements

You can schedule annoucements as follows:

`start_delivering_at` - Do not deliver this announcement until this date.

`stop_delivering_at` - Do not show this announcement to anyone after this date, not even to users who have seen the message before but not acknowledged it.

```ruby
Starburst::Announcement.create(:body => "Our app now features lots of balloons! Enjoy!", :start_delivering_at => Date.today, :stop_delivering_at => Date.today + 10.days)
```

<a name="targeting"></a>
## Targeting announcements

You can target announcements to particular users by setting the `limit_to_users` option.

The code below targets the announcement to users with a `subscription` field equal to `gold`.

```ruby
Starburst::Announcement.create(
	:body => '<a href="/upgrade">Upgrade to platinum</a> and save 10% with coupon code XYZ!',
	:limit_to_users =>
	[
		{
			:field => "subscription",
			:value => "gold"
		}
	]
)
```

## Advanced configuration

<a name="current_user"></a>
### Current user

Most Rails authentication libraries (like Devise and Clearance) place the current user into the `current_user` method. If your authentication library uses a different method, create an initializer for Starburst at `config/initializers/starburst.rb` and add the text below, replacing `current_user` with the name of the equivalent method in your authentication library.

```ruby
Starburst.configuration do |config|
	config.current_user_method = "current_user"
end
```

### Targeting by methods rather than fields

With targeting, you can limit which users will see a particular announcement. Out of the box, Starburst allows you to limit by fields in the database. However, your User model may have methods that don't directly map to database fields.

For instance, your User model might have an instance method `free?` that returns `true` if the user is on a free plan and `false` if they are on a paid plan. The actual field in the database may be called something different.

You can target based on methods that are not in the database, but you must specify those methods in a Starburst initializer. Create an initializer for Starburst at `config/initializers/starburst.rb` and add the text below:

```ruby
Starburst.configuration do |config|
	config.user_instance_methods  = ["free?"]
end
```

`user_instance_methods` is an array, so you can specify more than one method. All of the methods will be available for [targeting](#targeting), as if they were fields.

## Upgrading

### From 0.9.x to 1.0

This guidance applies only to users of Starburst who are upgrading from 0.9.x to 1.0.

**IMPORTANT**: This version introduces a uniqueness constraint on the AnnouncementView table. Before installing, you must find and clear out duplicate announcement views in the table:

1. In console on both the development and production environments, run `Starburst::AnnouncementView.select([:announcement_id,:user_id]).group(:announcement_id,:user_id).having("count(*) > 1").count` to find duplicate announcement views
2. Delete duplicate announcement views as necessary so you have only one of each. Use the `destroy` method on each individual view
3. Run `rake starburst:install:migrations` and then `rake db:migrate` on your development environment, then push to production

## Roadmap

* Targeting
  * Announcements for non-logged-in users
  * Announcement categories / locations
* Installation
  * Installation script to reduce steps
* Admin
  * Administrative interface for adding and editing announcements
  * Target announcements with operators other than `=` (ex. users created after a certain date)
  * Stats on how many messages are unread, read, and dismissed
* User
  * Archive of messages delivered to a particular user

Please add suggestions to the Issues tab in GitHub. Feel free to tweet the author at <a href="http://twitter.com/coreyitguy/">coreyITguy</a>.

## Contributors

Thanks to <a href="https://github.com/jhenkens/">jhenkens</a> for fixes, performance improvements, and ideas for showing announcements to non-logged-in users.
