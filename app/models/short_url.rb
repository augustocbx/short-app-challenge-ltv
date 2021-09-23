class ShortUrl < ApplicationRecord
  class << self
    def find_by_short_code(short_code)
      self.find(decode(short_code))
    end

    def encode(int)
      return if int.blank?
      return if !int.is_a? Numeric
      charecters_size = CHARACTERS.size
      s = ''
      while int > 0
        int, modulus = int.divmod(charecters_size)
        s = CHARACTERS[modulus] + s
      end
      s
    end

    def decode(str)
      return if str.blank?
      integer = 1
      answer = 0
      while character = str.slice!(-1)
        answer += CHARACTERS.index(character) * integer
        integer *= 62
      end
      return answer
    end
  end

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  scope :top_100, -> { order(click_count: :desc).limit(100) }

  validates :full_url, presence: true
  validate :validate_full_url

  def short_code
    self.class.encode(self.id)
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
    uri = URI.parse(self.full_url.to_s)
    if uri.blank? || uri.scheme != 'https' && uri.scheme != 'http'
      raise URI::InvalidURIError
    end
    return true
  rescue URI::InvalidURIError => e
    self.errors.add(:full_url, 'is not a valid url')
    return false
  end

end
