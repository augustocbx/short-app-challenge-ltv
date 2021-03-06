class ShortUrlsController < ApplicationApiController
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # Since we're working on an API, we don't have authenticity tokens
  # skip_before_action :verify_authenticity_token

  def index
    @urls = ShortUrl.top_100
  end

  def create
    @url = ShortUrl.create!(short_url_params)
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

  def record_invalid(error)
    @error = error

    render '/record_invalid'
  end

  def record_not_found(error)
    @error = error

    render '/record_not_found', status: :not_found
  end

end
