require 'test_helper'
require 'bcrypt'

class UserTest < ActiveSupport::TestCase

  test "user validates presence of username, email, name, and password" do
    invalid = User.new
    valid = User.new(name: "Test", email: "valid@email.com", username: "User1234", password: "Complex1234!")

    assert valid.valid?
    refute invalid.valid?
    assert_includes invalid.errors[:username], "can't be blank"
    assert_includes invalid.errors[:password], "can't be blank"
    assert_includes invalid.errors[:name], "can't be blank"
    assert_includes invalid.errors[:email], "can't be blank"
  end

  test "user validates password has at least 8 characters" do
    u = User.new(password: "Short_1")

    refute u.valid?
    assert_includes u.errors[:password], "must have at least 8 characters"
  end

  test "user validates password has at least 1 lowercase letter" do
    u = User.new(password: "NOLOWERCASE_1")

    refute u.valid?
    assert_includes u.errors[:password], "must have at least 1 lowercase letter"
  end

  test "user validates password has at least 1 uppercase letter" do
    u = User.new(password: "noupercase_1")

    refute u.valid?
    assert_includes u.errors[:password], "must have at least 1 uppercase letter"
  end

  test "user validates password has at least 1 number" do
    u = User.new(password: "COMPLEX_no_number")

    refute u.valid?
    assert_includes u.errors[:password], "must have at least 1 number"
  end

  test "user validates password has at least 1 symbol" do
    u = User.new(password: "COMPLEX1nosymbol")

    refute u.valid?
    assert_includes u.errors[:password], "must have at least 1 symbol"
  end

  test "user encrypts the password on password_digest" do
    u = User.new(password: "Complex1234!")

    refute_equal u.password, u.password_digest
  end

  test "password string can be authenticated by BCrypt using password_digest" do
    u = User.new(password: "Complex1234!")

    assert BCrypt::Password.new(u.password_digest).is_password?("Complex1234!")
    assert u.authenticate_password("Complex1234!")
  end

  test "user validates email format" do
    valid_email = User.new(email: "valid@email.com")
    invalid_email = User.new(email: "invalid_email")

    valid_email.valid?
    invalid_email.valid?

    refute_includes valid_email.errors[:email], 'is invalid'
    assert_includes invalid_email.errors[:email], 'is invalid'
  end

  test "user does not serializes password instance_value" do
    u = User.new(username: 'test', password: 'Test1234!')
    serialized = u.serializable_hash

    assert_includes serialized.keys, "username"
    assert_includes serialized.keys, "password_digest"
    refute_includes serialized.keys, "password"
  end

  test "can instantiate a valid User from json" do
    digest = BCrypt::Password.create("Test1234!")
    json = { username: "test", password_digest: digest, name: "Test", email: "email@valid.com" }.to_json

    user = User.from_json(json)

    assert user.valid?
  end
end
