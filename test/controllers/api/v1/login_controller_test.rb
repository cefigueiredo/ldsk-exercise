require 'test_helper'

class Api::V1::LoginControllerTest < ActionDispatch::IntegrationTest
  test 'POST /login creates an authentication token' do
    create_user(username: 'to_authorize')

    post '/api/v1/login', params: { username: 'to_authorize', password: 'Valid1234!' }

    response_body = JSON.parse(response.body)

    assert_response :success
    assert response_body["token"].present?
    remove_test_user('to_authorize')
  end
end
