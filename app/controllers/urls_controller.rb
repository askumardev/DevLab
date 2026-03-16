class UrlsController < ApplicationController

  # POST /urls
  def create
    url = Url.new(url_params)

    if url.save
      render json: {
        original_url: url.original_url,
        short_url: "#{request.base_url}/#{url.short_code}"
      }, status: :created
    else
      render json: { errors: url.errors.full_messages }, status: :unprocessable_entity
    end
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


  private

  def url_params
    params.require(:url).permit(:original_url)
  end

end

# class UrlsController < ApplicationController

#   # before_action :set_url, only: %i[ show edit update destroy ]

#   # # GET /urls or /urls.json
#   # def index
#   #   @urls = Url.all
#   # end

#   # # GET /urls/1 or /urls/1.json
#   # def show
#   # end

#   # # GET /urls/new
#   # def new
#   #   @url = Url.new
#   # end

#   # # GET /urls/1/edit
#   # def edit
#   # end

#   # # POST /urls or /urls.json
#   # def create
#   #   @url = Url.new(url_params)

#   #   respond_to do |format|
#   #     if @url.save
#   #       format.html { redirect_to @url, notice: "Url was successfully created." }
#   #       format.json { render :show, status: :created, location: @url }
#   #     else
#   #       format.html { render :new, status: :unprocessable_entity }
#   #       format.json { render json: @url.errors, status: :unprocessable_entity }
#   #     end
#   #   end
#   # end

#   # # PATCH/PUT /urls/1 or /urls/1.json
#   # def update
#   #   respond_to do |format|
#   #     if @url.update(url_params)
#   #       format.html { redirect_to @url, notice: "Url was successfully updated.", status: :see_other }
#   #       format.json { render :show, status: :ok, location: @url }
#   #     else
#   #       format.html { render :edit, status: :unprocessable_entity }
#   #       format.json { render json: @url.errors, status: :unprocessable_entity }
#   #     end
#   #   end
#   # end

#   # # DELETE /urls/1 or /urls/1.json
#   # def destroy
#   #   @url.destroy!

#   #   respond_to do |format|
#   #     format.html { redirect_to urls_path, notice: "Url was successfully destroyed.", status: :see_other }
#   #     format.json { head :no_content }
#   #   end
#   # end

#   # private
#   #   # Use callbacks to share common setup or constraints between actions.
#   #   def set_url
#   #     @url = Url.find(params[:id])
#   #   end

#   #   # Only allow a list of trusted parameters through.
#   #   def url_params
#   #     params.require(:url).permit(:original_url, :short_code)
#   #   end
# end
