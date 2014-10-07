# Starburst

[![Build Status](https://secure.travis-ci.org/csm123/starburst.svg?branch=master)](http://travis-ci.org/csm123/starburst)

Starburst allows you to show messages to logged in users within your Rails app. Once the user closes the message, Starburst won't show him or her the message again.

You can target messages to particular groups of users, based on their database attributes or your own methods on the User class. For instance, you might send a message only to users on your premium plan, or only to users who have been with the service for at least a month.

Starburst remembers _on the server_ who has read which message. Therefore, a user who acknowledges a message on their desktop won't see it again on their mobile device. This is an alternative to storing this information in cookies, which are specific to a device and are impacted by a user's privacy settings.

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

Starburst requires Rails 3.1 or greater.

## Installation

Add Starburst to your gemfile:

	gem "starburst"

Run the following commands:

	 rake starburst:install:migrations
	 rake db:migrate

Add the following line to your ApplicationController (app/controllers/starburst/application_controller.rb):

	helper Starburst::AnnouncementsHelper

Add the following line to your routes file (config/routes.rb):

	mount Starburst::Engine => "/starburst"

## Getting started

### Add an announcement partial to your app's layout

Starburst comes with pre-built announcement boxes for sites using Zurb Foundation and Twitter Bootstrap. It also includes an announcement box with no assigned styles.

If you are using Twitter Bootstrap in your app, add the following line to your app layout file, above <%= yield %>:

	<%= render :partial => "announcements/starburst/announcement_bootstrap" %>

If you are using Zurb Foundation in your app, add the following line to your app layout file, above <%= yield %>:

	<%= render :partial => "announcements/starburst/announcement_foundation" %>

If you are using neither Bootstrap nor Foundation, add the following line:

	<%= render :partial => "announcements/starburst/announcement" %>

### Add an announcement

Starburst doesn't have an admin interface yet, but you can add announcements through your own code.
	
	Announcement.create(:title => "Introducing balloons", :body => "Our app now features lots of balloons! Enjoy!")

This will present an announcement to every user of the app. Once they dismiss the announcement, they won't see it again.

Find out more about [scheduling announcements](#scheduling) and [targeting them to specific users](#targeting).

## Scheduling announcements

You can schedule annoucements as follows:

start_delivering_on - Do not deliver thsi announcement until this date.
stop_delivering_on - Do not show this announcement to anyone after this date, not even to users who have seen the message before but not acknowledged it.

## Targeting announcements

You can target annoucnements to particular users by setting the limit_to_users option.

MORE ON THE HASH HERE

## Roadmap

* Administrative interface for adding and editing announcements
* Easy way to get an archive of messages for a particular user
* Convenience methods to see which messages a particular user has and hasn't read
* Stats on how many messages are unread, read, and dismissed