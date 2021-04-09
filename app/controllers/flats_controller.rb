class FlatsController < ApplicationController
    before_action :set_flat, only: %i[ show edit update destroy ]

  def index
    @flats = Flat.all
    @markers = @flats.geocoded.map do |flat|
      {
        lat: flat.latitude,
        lng: flat.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { flat: flat }),
      }
    end
  end

  def new
    @flat = Flat.new
  end

  def create
    @flat = Flat.new(flat_params)
    if @flat.save
      redirect_to flats_path
    else
      render :new
    end
  end

  def edit
  end

    def update
    respond_to do |format|
      if @flat.update(flat_params)
        format.html { redirect_to @flat, notice: "Flat was successfully updated." }
        format.json { render :show, status: :ok, location: @flat }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @flat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flats/1 or /flats/1.json
  def destroy
    @flat.destroy
    respond_to do |format|
      format.html { redirect_to flats_url, notice: "Flat was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_flat
      @flat = Flat.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def flat_params
      params.require(:flat).permit(:name, :address)
    end

end
