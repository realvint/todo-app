# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require File.expand_path('../config/environment', __dir__)
ENV['RAILS_ENV'] ||= 'test'
require 'rspec/rails'
require 'spec_helper'
# require 'pundit/rspec'
# require "action_cable/testing/rspec"
include ActiveJob::TestHelper

FactoryBot::SyntaxRunner.class_eval do
  include ActionDispatch::TestProcess
end
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
# ActiveRecord::Migration.maintain_test_schema!
ActiveJob::Base.queue_adapter = :test
FactoryBot.rewind_sequences
Faker::UniqueGenerator.clear

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # for paperclip
  config.after(:suite) do
    FileUtils.rm_rf(Rails.root.join('tmp', 'storage'))
    # FileUtils.rm_rf("#{::Rails.root}/tmp/storage")
  end

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end
# Adding headers to request helper
def sign_in_test_headers(user)
  headers = {}
  headers['ACCEPT'] = 'application/json'
  headers['Authorization'] = 'Bearer ' + JsonWebToken.encode({user_id: user.id}).to_s
  headers
end

