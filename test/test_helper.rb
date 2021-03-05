ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"
require 'psych'
require 'json'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

# Methods to be available inside of fixture files
module FixtureFileHelpers
  def convert_JSON_results_files_to_fixtures(*years)
    hash_data = {}
    years.each do |year|
      path = "#{year}_results.rb"
      json_path = Rails.root.join('test/fixtures/files', path)
      array = JSON.load(json_path.read)
      array.each do |json_element|
        key = "id_#{json_element["id"]}"
        hash_data[key] = json_element
      end
    end
    Psych.dump(hash_data)
  end
end
ActiveRecord::FixtureSet.context_class.include FixtureFileHelpers
