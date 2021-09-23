class ShortUrlsController < ApplicationApiController

  # Since we're working on an API, we don't have authenticity tokens
  # skip_before_action :verify_authenticity_token

  def index
    @urls = ShortUrl.top_100
  end

  def create
    @url = ShortUrl.create(short_url_params)
    render :show
  end

  def show
  end

  def short_url_params
    params.permit(:full_url)
  end

end
