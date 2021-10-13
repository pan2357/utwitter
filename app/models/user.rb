class User < ApplicationRecord
    has_secure_password
    has_many :posts, dependent: :destroy
    validates :email, uniqueness: { case_sensitive: false }
    validates :email, presence: true
    validates :name, presence: true
    validates :password, presence: true
    validates :password, length: { minimum: 10 }
    validates :password, confirmation: { case_sensitive: true }
end
