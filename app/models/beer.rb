class Beer < ApplicationRecord
  include RatingAverage
  belongs_to :brewery, touch: true
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user
  belongs_to :style

  validates :name, presence: true
  validates :style, presence: true

  def self.top(amount)
    sorted_by_rating_in_desc_order = Beer.all.sort_by{ |b| -(b.average_rating || 0) }
    sorted_by_rating_in_desc_order.take amount
  end

  def to_s
    "#{name} (#{brewery.name})"
  end
end
