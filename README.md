![Impressionist Logo](https://github.com/charlotte-ruby/impressionist/raw/master/logo.png)

[![Build Status](https://secure.travis-ci.org/charlotte-ruby/impressionist.png?branch=master)](http://travis-ci.org/charlotte-ruby/impressionist)
[![Code Climate](https://codeclimate.com/github/charlotte-ruby/impressionist.png)](https://codeclimate.com/github/charlotte-ruby/impressionist)

impressionist
=============

A lightweight plugin that logs impressions per action or manually per model

--------------------------------------------------------------------------------

What does this thing do?
------------------------
Logs an impression... and I use that term loosely.  It can log page impressions
(technically action impressions), but it is not limited to that. You can log
impressions multiple times per request.  And you can also attach it to a model.
The goal of this project is to provide customizable stats that are immediately
accessible in your application as opposed to using Google Analytics and pulling
data using their API.  You can attach custom messages to impressions.  No
reporting yet.. this thingy just creates the data.

What about bots?
----------------
They are ignored.  1200 known bots have been added to the ignore list as of
February 1, 2011.  Impressionist uses this list:
http://www.user-agents.org/allagents.xml

Installation
------------
Add it to your Gemfile

    gem 'impressionist'

Install with Bundler

    bundle install

Generate the impressions table migration

    rails g impressionist

Run the migration

    rake db:migrate

The following fields are provided in the migration:

    t.string   "impressionable_type"  # model type: Widget
    t.integer  "impressionable_id"    # model instance ID: @widget.id
    t.integer  "user_id"              # automatically logs @current_user.id
    t.string   "controller_name"      # logs the controller name
    t.string   "action_name"          # logs the action_name
    t.string   "view_name"            # TODO: log individual views (as well as partials and nested partials)
    t.string   "request_hash"         # unique ID per request, in case you want to log multiple impressions and group them
    t.string   "session_hash"         # logs the rails session
    t.string   "ip_address"           # request.remote_ip
    t.text     "params"               # request.params, except action name, controller name and resource id
    t.string   "referrer"             # request.referer
    t.string   "message"              # custom message you can add
    t.datetime "created_at"           # I am not sure what this is.... Any clue?
    t.datetime "updated_at"           # never seen this one before either....  Your guess is as good as mine?? ;-)

Usage
-----

1. Log all actions in a controller

        WidgetsController < ApplicationController
          impressionist
        end

2. Specify actions you want logged in a controller

        WidgetsController < ApplicationController
          impressionist :actions=>[:show,:index]
        end

3. Make your models impressionable.  This allows you to attach impressions to
   an AR model instance.  Impressionist will automatically log the Model name
   (based on action_name) and the id (based on params[:id]), but in order to
   get the count of impressions (example: @widget.impression_count), you will
   need to make your model impressionable

        class Widget < ActiveRecord::Base
          is_impressionable
        end

4. Log an impression per model instance in your controller.  Note that it is
   not necessary to specify "impressionist" (usage #1) in the top of you
   controller if you are using this method.  If you add "impressionist" to the
   top of your controller and also use this method in your action, it will
   result in 2 impressions being logged (but associated with one request_hash).
   If you're using [friendly_id](https://github.com/norman/friendly_id) be sure
   to log impressionist this way, as params[:id] will return a string(url slug)
   while impressionable_id is a Integer column in database. Also note that you
   have to take step #3 for the Widget model for this to work.

        def show
          @widget = Widget.find
          impressionist(@widget, "message...") # 2nd argument is optional
        end

5. Get unique impression count from a model.  This groups impressions by
   request_hash, so if you logged multiple impressions per request, it will
   only count them one time.  This unique impression count will not filter out
   unique users, only unique requests

        @widget.impressionist_count
        @widget.impressionist_count(:start_date=>"2011-01-01",:end_date=>"2011-01-05")
        @widget.impressionist_count(:start_date=>"2011-01-01")  #specify start date only, end date = now

6. Get the unique impression count from a model filtered by IP address.  This
   in turn will give you impressions with unique request_hash, since rows with
   the same request_hash will have the same IP address.

        @widget.impressionist_count(:filter=>:ip_address)

7. Get the unique impression count from a model filtered by params.  This
   in turn will give you impressions with unique params.

        @widget.impressionist_count(:filter => :params)

8. Get the unique impression count from a model filtered by session hash.  Same
   as #6 regarding request hash.  This may be more desirable than filtering by
   IP address depending on your situation, since filtering by IP may ignore
   visitors that use the same IP.  The downside to this filtering is that a
   user could clear session data in their browser and skew the results.

        @widget.impressionist_count(:filter=>:session_hash)

9. Get total impression count.  This may return more than 1 impression per http
   request, depending on how you are logging impressions

        @widget.impressionist_count(:filter=>:all)

10. Get impression count by message.  This only counts impressions of the given message.

        @widget.impressionist_count(:message=>"pageview", :filter=>:all)

Logging impressions for authenticated users happens automatically.  If you have
a current_user helper or use @current_user in your before_filter (or before_action in Rails >= 5.0) to set your
authenticated user, current_user.id will be written to the user_id field in the
impressions table.

Adding a counter cache
----------------------
Impressionist makes it easy to add a `counter_cache` column to your model. The
most basic configuration looks like:

    is_impressionable :counter_cache => true

This will automatically increment the `impressions_count` column in the
included model. <b>Note: You'll need to add that column to your model. If you'd
like specific a different column name, you can:</b>

    is_impressionable :counter_cache => true, :column_name => :my_column_name

If you'd like to include only unique impressions in your count:

    # default will be filtered by ip_address
    is_impressionable :counter_cache => true, :column_name => :my_column_name, :unique => true

If you'd like to specify what sort of unique impression you'd like to save? Fear not,
Any option you pass to unique, impressionist_count will use it as its filter to update_counters based on that unique option.

    # options are any column in the impressions' table.
    is_impressionable :counter_cache => true, :column_name => :my_column_name, :unique => :request_hash
    is_impressionable :counter_cache => true, :column_name => :my_column_name, :unique => :all


Adding column to model
----------------------
It is as simple as this:

    t.integer :my_column_name, :default => 0

If you want to use the typical Rails 4 migration generator, you can:

    rails g migration AddImpressionsCountToBook impressions_count:int

What if I only want to record unique impressions?
-------------------------------------------------
Maybe you only care about unique impressions and would like to avoid
unnecessary database records. You can specify conditions for recording
impressions in your controller:

    # only record impression if the request has a unique combination of type, id, and session
    impressionist :unique => [:impressionable_type, :impressionable_id, :session_hash]

    # only record impression if the request has a unique combination of controller, action, and session
    impressionist :unique => [:controller_name, :action_name, :session_hash]

    # only record impression if session is unique
    impressionist :unique => [:session_hash]

    # only record impression if param is unique
    impressionist :unique => [:params]

Or you can use the `impressionist` method directly:

    impressionist(impressionable, "some message", :unique => [:session_hash])

Are you using Mongoid?
---------------------

Execute this command on your terminal/console:

    rails g impressionist --orm mongoid

This command create a file `impression.rb` on `config/initializer` folder. Add `config.orm = :mongoid` to this file:

    # Use this hook to configure impressionist parameters
    Impressionist.setup do |config|
      # Define ORM. Could be :active_record (default), :mongo_mapper or :mongoid
      # config.orm = :active_record
      config.orm = :mongoid
    end


Contributing to impressionist
-----------------------------
* Check out the latest master to make sure the feature hasn't been implemented
  or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it
  and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add rpsec tests for it. Patches or features without tests will
  be ignored.  Also, try to write better tests than I do ;-)
* If adding engine controller or view functionality, use HAML and Inherited
  Resources.
* All testing is done inside a small Rails app (test_app).  You will find specs
  within this app.


Want to run the tests? Ok mummy
-------------------------------
* bundle install
* rails g impressionist
* rake db:migrate && rake db:test:prepare
* Run rake or rspec spec inside test_app dir
* nothing else.
* :wq

Contributors
------------
* [johnmcaliley - creator](https://github.com/johnmcaliley)
* [jgrau - maintainer](https://github.com/jgrau)
* [acnalesso](https://github.com/acnalesso)
* [coryschires](https://github.com/coryschires)
* [georgmittendorfer](https://github.com/georgmittendorfer)


Copyright (c) 2011 John McAliley. See LICENSE.txt for further details.
