class ShortUrl < ApplicationRecord
  class << self
    def find_by_short_code(short_code)
      self.find(short_code)
    end
  end

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  scope :top_100, -> { order(click_count: :desc).limit(100) }

  validates :full_url, presence: true
  validate :validate_full_url

  def short_code
    self.id
  end

  def update_title!
  end

  def increment_click_count!
    self.update(click_count: self.click_count + 1)
  end

  def public_attributes
    self.slice('short_code', 'full_url', 'title', 'click_count')
  end

  private

  def validate_full_url
  end

end
