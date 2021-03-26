class User < ApplicationRecord
  before_save { self.email = self.email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  has_secure_password
  validates :username, uniqueness: { case_sensitive: false }, presence: true, length: { maximum: 25 }
  validates :password, presence: true, length: { minimum: 8 }
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: true

  def as_json(options = {})
    # options hash accepts four keys for customization :only, :methods, :include, :except
    if options.key?(:only) || options.key?(:methods) ||
       options.key?(:include) || options.key?(:except)
      super(options)
    else
      super(only: [:username, :created_at])
    end
  end
end
