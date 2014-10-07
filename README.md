# Starburst

[![Build Status](https://secure.travis-ci.org/csm123/starburst.svg?branch=master)](http://travis-ci.org/csm123/starburst)
[![Code Climate](https://codeclimate.com/github/csm123/starburst/badges/gpa.svg)](https://codeclimate.com/github/csm123/starburst)

**Starburst is in pre-release at version 0.9, though tests are passing. Please test this in your apps and report any issues to the Issues tab.**

Starburst allows you to show messages to logged in users within your Rails app. Once the user closes the message, they won't see it again.

You can target messages to particular groups of users, based on their database attributes or your own methods on the User class. For instance, you might send a message only to users on your premium plan, or only to users who have been with the service for at least a month.

Starburst remembers _on the server_ who has closed which message. Therefore, a user who closes a message on their desktop won't see it again on their mobile device. This is an alternative to storing this information in cookies, which are specific to a device and are impacted by a user's privacy settings.

[![Announcement in Zurb Foundation](http://aspiringwebdev.com/wp-content/uploads/2014/10/Screen-Shot-2014-10-07-at-7.20.50-PM.png)](#)

## Use cases

You may want to share with your users:

- A new feature announcement
- Warning about upcoming downtime
- A special coupon to upgrade to a premium plan

In any case, users will see the message until they dismiss it, and then it won't appear again.

## Requirements

### Authentication system like Devise or Clearance
Starburst needs to know who is currenty logged in. If you are using Devise or Clearance, Starburst will look at the current_user object automatically.

If you are using a different authentication system that does not have a current_user object, see advanced configuration below.

### Ruby and Rails

Starburst [works](https://secure.travis-ci.org/csm123/starburst) on Rails 3 and 4, and Ruby 1 and 2.

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

If you are using Twitter Bootstrap in your app, add the following line to your app layout file, above <%= yield %>:

```erb
<%= render :partial => "announcements/starburst/announcement_bootstrap" %>
```

If you are using Zurb Foundation in your app, add the following line to your app layout file, above <%= yield %>:

```erb
<%= render :partial => "announcements/starburst/announcement_foundation" %>
```

If you are using neither Bootstrap nor Foundation, add the following line. You'll need to define your own styles; you can use  `#starburst-announcement` ID for the box, and the `#starburst-close` for the close button.

```erb
<%= render :partial => "announcements/starburst/announcement" %>
```

### Add an announcement

Starburst doesn't have an admin interface yet, but you can add announcements through your own code.

```ruby
Announcement.create(:title => "Introducing balloons", :body => "Our app now features lots of balloons! Enjoy!")
```

This will present an announcement to every user of the app. Once they dismiss the announcement, they won't see it again.

Find out more about [scheduling announcements](#scheduling) and [targeting them to specific users](#targeting).

<a name="scheduling"></a>
## Scheduling announcements 

You can schedule annoucements as follows:

`start_delivering_at` - Do not deliver this announcement until this date.

`stop_delivering_at` - Do not show this announcement to anyone after this date, not even to users who have seen the message before but not acknowledged it.

```ruby
Announcement.create(:start_delivering_at => Date.today, :stop_delivering_at => Date.today + 10.days)
```

<a name="targeting"></a>
## Targeting announcements

You can target announcements to particular users by setting the `limit_to_users` option.

The code below targets the announcement to users with a `subscription` field equal to `gold`.

```ruby
Announcement.create(:limit_to_users => 
	[
		{
			:field => "subscription",
			:value => "gold"
		}
	],
	:body => '<a href="/upgrade">Upgrade to platinum</a> and save 10% with coupon code XYZ!'
)
```

## Advanced configuration

### Current user

Most Rails authentication libraries (like Devise and Clearance) place the current user into the `current_user` method. If your authenticaiton library uses a different method, create an initializer for Starburst at `config/initializers/starburst.rb` and add the text below, replacing `current_user` with the name of the equivalent method in your authentication library.

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

## Roadmap

* Installation
  * Installation script to reduce steps
* Admin
  * Administrative interface for adding and editing announcements
  * Target annoucements with operators other than `=` (ex. users created after a certain date)
  * Stats on how many messages are unread, read, and dismissed
* User
  * Archive of messages delivered to a particular user

Please add suggestions to the Issues tab in GitHub.
