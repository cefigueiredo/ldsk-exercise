require 'bcrypt'

class User
  include ActiveModel::Model
  include ActiveModel::SecurePassword

  PASSWORD_COMPLEXITY_REQUIREMENT = %r{\A
            # at least 1 lowercase letter
    (?=.*[A-Z])        # at least 1 uppercase letter
    (?=.*\d)           # at least 1 number
    (?=.*[[:^alnum:]]) # at least 1 symbol
  }x

  attr_accessor :username, :email, :password_digest, :name

  has_secure_password

  validates :username, :email, :name, presence: true

  validates_each :password, allow_nil: true do |model, attr, value|
    model.errors.add attr, 'must have at least 8 characters' unless /\A(?=.{8,})/.match? value
    model.errors.add attr, 'must have at least 1 lowercase letter' unless /\A(?=.*[a-z])/.match? value
    model.errors.add attr, 'must have at least 1 uppercase letter' unless /\A(?=.*[A-Z])/.match? value
    model.errors.add attr, 'must have at least 1 number' unless /\A(?=.*\d)/.match? value
    model.errors.add attr, 'must have at least 1 symbol' unless /\A(?=.*[[:^alnum:]])/.match? value
  end

end
