# app/controllers/appointments_controller.rb
class AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[edit update destroy]

  def index
    if params[:month] && params[:year]
      @date = Date.new(params[:year].to_i, params[:month].to_i, 1)
    else
      @date = params[:date] ? Date.parse(params[:date]) : Date.today
    end
    @appointments = Appointment.all
  end

  def create
    @appointment = Appointment.new(appointment_params)

    if @appointment.save
      redirect_to appointments_path, notice: "Booked!"
    else
      render :index
    end
  end

  def edit; end

  def update
    if @appointment.update(appointment_params)
      redirect_to appointments_path, notice: "Updated!"
    else
      render :edit
    end
  end

  def destroy
    @appointment.destroy
    redirect_to appointments_path, notice: "Appointment deleted!"
  end

  private

  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  def appointment_params
    params.require(:appointment).permit(:title, :start_time, :end_time)
  end
end
