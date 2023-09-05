class User < ApplicationRecord 
  validates :email, uniqueness: true, presence: true
  validates_presence_of :name, allow_blank: false
  validates_presence_of :password, allow_blank: false
  validates_presence_of :password_confirmation, allow_blank: false

  has_secure_password
end 