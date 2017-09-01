class ApiUser < ApplicationRecord
  before_create :create_token
  
  def create_token
    self.api_key = SecureRandom.base64(10)
  end

end
