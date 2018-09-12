module RatingAverage
  extend ActiveSupport::Concern

  def average_rating()
    if ratings.size == 0
      0
    else
      ratings.reduce(0.0) { |sum, rating| sum + rating.score } / ratings.size
    end
  end
end