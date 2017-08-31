class ApiUser < ApplicationRecord
  protect_from_forgery with: :null_session
  before_action :restrict_access
  before_create :create_token

  def restrict_access
    authenticate_or_request_with_http_token do |api_key, options|
      User.find_by(email: request.headers['X-User-Email'], api_key: api_key)
    end
  end
  
  def create_token
    self.api_key = SecureRandom.base64(10)
  end

end
