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

  def self.create_oauth_user(username)
    password = SecureRandom.urlsafe_base64(n=6)
    User.create username: username, password: password
  end

  def self.top(amount)
    sorted_by_rating_in_desc_order = User.all.sort_by{ |u| -(u.ratings.count || 0) }
    sorted_by_rating_in_desc_order.take amount
  end

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    favorite(:style)
  end

  def favorite_brewery
    favorite(:brewery)
  end

  def favorite(groupped_by)
    return nil if ratings.empty?

    grouped_ratings = ratings.group_by{ |r| r.beer.send(groupped_by) }
    averages = grouped_ratings.map do |group, ratings|
      { group: group, score: average_of(ratings) }
    end

    averages.max_by{ |r| r[:score] }[:group]
  end

  def average_of(ratings)
    ratings.sum(&:score).to_f / ratings.count
  end
end
