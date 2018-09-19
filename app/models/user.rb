class User < ApplicationRecord
  include RatingAverage

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships
  has_secure_password

  validates :username, uniqueness: true,
                       length: { in: 3..30 }
  validates :password, length: { minimum: 4 },
                       format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).*\z/,
                                 message: "must contain a lowercase letter, an uppercase letter and a digit" }
end
