class Style < ApplicationRecord
  include RatingAverage
  has_many :beers
  has_many :ratings, through: :beers

  def self.top(amount)
    sorted_by_rating_in_desc_order = Style.all.sort_by{ |s| -(s.average_rating || 0) }
    sorted_by_rating_in_desc_order.take amount
  end

  def to_s
    name.to_s
  end
end
