# This fie is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'simplecov'

SimpleCov.minimum_coverage 90
SimpleCov.start do
  add_group 'Models', ['app/models', 'spec/models']
  add_group 'Controllers', ['app/controllers', 'spec/controllers']
end
# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include FactoryGirl::Syntax::Methods
  config.include ApplicationHelper

  config.include FactoryGirl::Syntax::Methods

  DatabaseCleaner.orm = 'active_record'

  config.infer_spec_type_from_file_location!
  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'

  config.before(:suite) do
    FactoryGirl.lint
    DatabaseCleaner.clean_with :truncation
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
