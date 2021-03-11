class User < ApplicationRecord
  has_secure_password
  validates :username, uniqueness: { case_sensitive: false }, presence: true, length: { maximum: 25 }
  validates :password, presence: true, length: { minimum: 8 }

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
