class TourAvailabilitiesController < ApplicationController
  before_action :set_tour
  before_action :set_tour_availability, only: %i[edit update destroy ]

  # GET /tour_availabilities/new
  def new
    @tour_availability = TourAvailability.new
  end

  # GET /tour_availabilities/1/edit
  def edit
  end

  # POST /tour_availabilities or /tour_availabilities.json
  def create
    @tour_availability = TourAvailability.new(tour_availability_params)
    @tour_availability.tour = @tour

    respond_to do |format|
      if @tour_availability.save
        format.html { redirect_to tour_url(@tour), notice: "Tour availability was successfully created." }
        format.json { render :show, status: :created, location: @tour_availability }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tour_availability.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tour_availabilities/1 or /tour_availabilities/1.json
  def update
    respond_to do |format|
      if @tour_availability.update(tour_availability_params)
        format.html { redirect_to tour_url(@tour), notice: "Tour availability was successfully updated." }
        format.json { render :show, status: :ok, location: @tour_availability }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tour_availability.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tour_availabilities/1 or /tour_availabilities/1.json
  def destroy
    @tour_availability.destroy!

    respond_to do |format|
      format.html { redirect_to tour_url(@tour), notice: "Tour availability was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tour
      @tour = Tour.find(params[:tour_id])
    end

    def set_tour_availability
      @tour_availability = TourAvailability.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tour_availability_params
      params.require(:tour_availability).permit(:start_date, :start_time, :end_date, :end_time, :recur_type, :recur_frequency, :recur_days, :recur_month, :recur_end_date, :recur_end_occurrence)
    end
end
