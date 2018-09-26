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

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    rated_styles_average = ratings.group_by{ |r| r.beer.style }.map do |style, rs|
      ratings_sum = rs.reduce(0){ |sum, r| sum + r.score }
      { style: style, average: ratings_sum / rs.size }
    end
    rated_styles_average.max_by{ |hsh| hsh[:average] }[:style]
  end

  def favorite_brewery
    return nil if ratings.empty?

    rated_breweries_average = ratings.group_by{ |r| r.beer.brewery }.map do |brewery, rs|
      ratings_sum = rs.reduce(0){ |sum, r| sum + r.score }
      { brewery: brewery, average: ratings_sum / rs.size }
    end
    rated_breweries_average.max_by{ |hsh| hsh[:average] }[:brewery]
  end
end
