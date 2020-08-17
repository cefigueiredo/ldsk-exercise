class Session
  include ActiveModel::Model

  BASE_SESSION_KEY = 'lendesk:challenge:session'

  attr_accessor :user_key

  def user
    @user ||= User.find_by_key(user_key)
  end

  def self.create_token(username)
    token = SecureRandom.base58(24)
    expires_at = 10.minutes.from_now.utc
    key = "#{BASE_SESSION_KEY}-#{token}"

    REDIS.multi do
      REDIS.hset key, { user_key: User.user_key(username) }
      REDIS.expireat key, expires_at.to_i
    end

    { token: token, expires_at: expires_at.rfc3339 }
  end

  def self.find_from_token(token)
    session = REDIS.hgetall("#{BASE_SESSION_KEY}-#{token}")

    Session.new(user_key: session["user_key"])
  end
end
