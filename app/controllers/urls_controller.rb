class UrlsController < ApplicationController

  def new
    @url = Url.new
  end

  # POST /urls
  def create
    @url = Url.new(url_params)

    if @url.save
      @url.update(tiny_url: "#{request.base_url}/#{@url.short_code}")
      redirect_to @url, notice: 'URL was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @url = Url.find(params[:id])
  end

  # GET /:short_code
  def redirect
    url = Url.find_by(short_code: params[:short_code])

    Rails.logger.info "Short code received: #{params[:short_code]}"
    Rails.logger.info "URL found: #{url.inspect}"

    if url
      redirect_to url.original_url, allow_other_host: true
    else
      render json: { error: "URL not found" }, status: :not_found
    end
  end

  def index
    @urls = Url.all
  end

  private

  def url_params
    params.require(:url).permit(:original_url)
  end
end