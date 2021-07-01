class ReservationsController < ApplicationController
  before_action :set_reservation, only: %i[ show destroy ]

  # GET /reservations or /reservations.json
  def index
    @reservations = Reservation.all.where(user_id: current_user.id)
  end

  # GET /reservations/1 or /reservations/1.json
  def show
    redirect_to reservations_path
  end

  # DELETE /reservations/1 or /reservations/1.json
  def destroy
    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to reservations_url, notice: "Reservation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      begin
        @reservation = Reservation.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to reservation_path
      end
    end

    # Only allow a list of trusted parameters through.
    def reservation_params
      params.require(:reservation).permit(:start_date, :end_date)
    end
end
