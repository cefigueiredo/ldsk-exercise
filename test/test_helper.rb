ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  #
  def remove_test_user(username)
    REDIS.del(User.user_key(username))
  end

  def create_user(params = {})
    user_params = { name: 'Test', username: 'test-1', email: 'test@email.com', password: 'Valid1234!' }.merge(params)

    User.new(user_params).save
  end
end

User::BASE_USER_KEY = 'lendesk:challenge:test:user'

