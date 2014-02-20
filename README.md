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

    gem 'impressionist', '~> 2.0.rc1'

Install with Bundler

    bundle install

Generate the impressions table migration

    rails g impressionist:install

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
    t.string   "referrer"             # request.referer
    t.string   "message"              # custom message you can add
    t.datetime "created_at"           # I am not sure what this is.... Any clue?
    t.datetime "updated_at"           # never seen this one before either....  Your guess is as good as mine?? ;-)

Usage
-----

1. Add minions i.e controller's actions to a controller in <b>config/initializers/impressionist.rb</b>

        Impressionist.setup do
          MinionCreate.setup do
            add( :controller_name, :actions, :options )
          end
        end

2. Log all actions for a given controller

        add( :widgets, :all )

3. Log some actions and use a different cache object ( i.e model )

        add( :rates, [:index, :show], cache_class: "MyOwnCacheModel" )

4. Logs some actions with default options

        add( :comments, [:index, :show] )

5. Logs one action with a different class object ( i.e model is not the same name as controllers' )

        add( :posts, :index, class_name: "Scrap" )

6. Logs only unique impressions

        add( :lobster, [ :show, :edit ], unique: true )

7. Logs actions based on unique's parameters

        add( :logs, :all, unique: [ :request_hash, :ip_address ] )

If I want to add extra info to be saved with a particular impression?
--------------------------------------------------------------------

Fear Not!!!
Given you have added minions, actions to controllers, you just have to override this method on the controller:

        class WidgetsController < ApplicationController

          def append_to_imp(payload)
            payload[:papoy] = "A toy :)"
          end

        end

Good to know
------------

Here is the payload, hash, impressionist uses to save an impression.
Note this hash is returned from an instrumentation impressionist does for every action, minion, added.
The instrumentation is "process_impression.impressionist" just in case one would like to subscribe to it.

    {
      action:     self.action_name,
      params:     request.filtered_parameters,
      format:     request.format.try(:ref),
      path:       (request.fullpath rescue "unknown"),
      status:     response.status,
      user_agent: request.user_agent,
      ip_address: request.ip_address
    }
