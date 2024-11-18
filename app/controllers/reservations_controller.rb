class ReservationsController < ApplicationController
  def index
    @reservations = Reservation.includes(:tables).order(status: :asc, reservation_time: :asc, reservation_capacity: :asc)
  end

  def new
    @reservation = Reservation.new
  end

  def create
    @reservation = Reservation.new(reservation_params)
    if @reservation.save
      flash[:notice] = 'Reservation created successfully!'
      redirect_to reservations_path
    else
      flash.now[:alert] = @reservation.errors.full_messages.join("\n")
      render :new, status: :unprocessable_entity
    end
  end

  def cancel
    @reservation = Reservation.find(params[:id])
    @reservation.update!(status: :cancelled)
    flash[:notice] = 'Reservation cancelled successfully!'

    redirect_to reservations_path
  end

  private

  def reservation_params
    params.require(:reservation).permit(:name, :reservation_time, :reservation_capacity, :duration)
  end
end
