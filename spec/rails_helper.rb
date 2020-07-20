require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'

require 'rails/all'
require 'rspec/rails'

require File.expand_path('./test_app/config/environment', __dir__)

RSpec.configure do |config|
end
