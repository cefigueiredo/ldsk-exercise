require 'test_helper'

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    remove_test_user('test-1')
  end

  def teardown
    remove_test_user('test-1')
  end

  test "POST /users creates a new user" do
    post '/api/v1/users', params: { username: 'test-1', name: 'Test 1', email: 'test1@email.com', password: 'Valid1234!' }

    assert_response :success
    assert_equal 'test-1', JSON.parse(response.body)["username"]
  end

  test "POST /users return error if user already exists" do
    create_user(username: 'test-1')

    post '/api/v1/users', params: { username: 'test-1', name: 'Test 1', email: 'test1@email.com', password: 'Valid1234!' }

    assert_response :bad_request
    assert_equal 'User already exists', JSON.parse(response.body)["error"]
  end

  test 'GET /users lists users' do
    create_user(username: 'test-1')
    create_user(username: 'test-2')

    get '/api/v1/users'

    assert_response :success
    assert_equal 2, JSON.parse(response.body)["users"].count
    remove_test_user('test-1')
    remove_test_user('test-2')
  end

  test 'GET /users/:username fetch the user' do
    create_user(username: 'test-1')

    get '/api/v1/users/test-1'

    assert_response :success
    assert_equal 'test-1', JSON.parse(response.body)["username"]
  end
end
