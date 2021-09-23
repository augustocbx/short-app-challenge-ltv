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
    @url = ShortUrl.find_by_short_code(params[:id])
    @url.increment_click_count!
    redirect_to @url.full_url and return
  end

  def short_url_params
    params.permit(:full_url)
  end

end
