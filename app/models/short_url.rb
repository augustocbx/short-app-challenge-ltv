class ShortUrl < ApplicationRecord
  class << self
    def find_by_short_code(short_code)
      self.find(decode(short_code))
    end

    def encode(int)
      return if int.blank?
      return unless int.is_a? Numeric

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

  after_create :enqueue_update_title

  def short_code
    self.class.encode(self.id)
  end

  def update_title!
    uri = self.full_url
    i = 3
    begin
      i -= 1
      response = Net::HTTP.get_response(URI.parse(uri))
      uri = response['location']
    end while !i.zero? && response.is_a?(Net::HTTPRedirection)
    title = Nokogiri.HTML(response.body).at_css('title').text
    if title
      self.update(title: title)
    end
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
    raise URI::InvalidURIError unless (uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS))

    return true
  rescue URI::InvalidURIError
    self.errors.add(:full_url, 'is not a valid url')
    return false
  end

end
