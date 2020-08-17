require 'bcrypt'

class User
  include ActiveModel::Model
  include ActiveModel::SecurePassword
  include ActiveModel::Serializers
  include ActiveModel::Serializers::JSON

  USER_ATTRIBUTES = [:username, :email, :password_digest, :name]

  attr_accessor :username, :email, :password_digest, :name

  has_secure_password

  validates :username, :email, :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates_each :password, allow_nil: true do |model, attr, value|
    model.errors.add attr, 'must have at least 8 characters' unless /\A(?=.{8,})/.match? value
    model.errors.add attr, 'must have at least 1 lowercase letter' unless /\A(?=.*[a-z])/.match? value
    model.errors.add attr, 'must have at least 1 uppercase letter' unless /\A(?=.*[A-Z])/.match? value
    model.errors.add attr, 'must have at least 1 number' unless /\A(?=.*\d)/.match? value
    model.errors.add attr, 'must have at least 1 symbol' unless /\A(?=.*[[:^alnum:]])/.match? value
  end

  # attributes to be serialized. All attributes except non encrypted password
  def attributes
    instance_values.with_indifferent_access.slice(*USER_ATTRIBUTES)
  end

  # requirement to instantiate User from a json
  def attributes=(hash)
    hash.each do |key, value|
      send("#{key}=", value)
    end
  end

  def user_key
    self.class.user_key(username)
  end

  def persisted?
    self.class.exists?(username)
  end

  def save
    return false unless valid?

    REDIS.hset user_key, attributes
  end

  class << self
    def from_json(json)
      User.new.from_json(json)
    end

    def user_key(username)
      "user-#{username.parameterize}"
    end

    def exists?(username)
      REDIS.exists?(user_key(username))
    end

    def find_by_username(username)
      return nil unless exists?(username)

      hash = REDIS.hgetall(user_key(username)).symbolize_keys.slice(*USER_ATTRIBUTES)
      User.new(**hash)
    end
  end
end
