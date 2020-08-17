class ApplicationController < ActionController::API
  def authenticate!
    request.env['warden'].authenticate!
  end
end
