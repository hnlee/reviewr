########################### added ############################

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Add this to load Capybara integration:
require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'

# Factory Girl
require 'support/factory_girl'

# OmniAuth
OmniAuth.config.test_mode = true

RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers
  config.include Capybara::DSL
  config.use_transactional_fixtures = false
  config.shared_context_metadata_behavior = :apply_to_host_groups
  
  Capybara.javascript_driver = :poltergeist 
  
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

module ::RSpec::Code
  class ExampleGroup
    include Capybara::DSL
    include Capybara::RSpecMatchers
  end
end
