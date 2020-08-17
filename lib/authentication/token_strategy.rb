require 'warden'

module Authentication
  class TokenStrategy < Warden::Strategies::Base
    def valid?
      access_token.present?
    end

    def authenticate!
      session = Session.find_from_token(access_token)

      if session.nil?
        fail!('Could not log in')
      else
        success!(session.user)
      end
    end

    private

    def access_token
      @access_token ||= request.get_header('access_token')
    end
  end
end
