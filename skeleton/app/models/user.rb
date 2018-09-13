class User < ApplicationRecord
  validates :username, :password_digest, presence: true 
  validates :session_token, uniqueness: true 
  
  after_initialize :ensure_session_token
  
  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end 
  
  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
    self.session_token
  end
  
  def password=(pw)
    @password = pw 
    self.password_digest = BCrypt::Password.create(pw)
  end 
  
  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end 
  
  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    if user.nil?
      nil
    else
      return user if user.is_password?(password)
    end
  end
end
