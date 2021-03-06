class BoatsController < ApplicationController
  before_action :set_boat, only: [:show, :edit, :update, :destroy]

  def index
    @boats = policy_scope(Boat).order(created_at: :desc)
    @boats = Boat.where.not(latitude: nil, longitude: nil)
    @markers = @boats.map do |boat|
      {
        lat: boat.latitude,
        lng: boat.longitude#,
        # infoWindow: { content: render_to_string(partial: "/flats/map_box", locals: { flat: flat }) }
      }
    end
  end

  def show
   @marker = [{
      lat: @boat.latitude,
      lng: @boat.longitude#,
        # infoWindow: { content: render_to_string(partial: "/flats/map_box", locals: { flat: flat }) }
      }] if (@boat.latitude.present? && @boat.longitude.present?)
    @bookings = []
    sum_rate = 0
    num_bookings = 0
    @boat.bookings.each do |booking|
      @bookings << [booking.start_date, booking.end_date]
      num_bookings += 1
      unless booking.reviews.first == nil
        sum_rate += booking.reviews.first.rating
      end
    end
    num_bookings.to_i > 0 ? @boat.stars = sum_rate.to_i / num_bookings.to_i : @boat.stars = 0
    @booking = Booking.new
    authorize @boat
  end

  def new
    @boat = Boat.new
    authorize @boat
  end

  def edit
    authorize @boat
  end

  def create
    @boat = Boat.new(boat_params)
    @boat.owner = current_user
    authorize @boat
    @boat.save!
    if @boat.save
      redirect_to dashboard_owner_path
    else
      render :new
    end
  end

  def update
    @boat.update(boat_params)
    authorize @boat
    if @boat.update(boat_params)
      redirect_to boat_path(@boat)
    else
      render :edit
    end
  end

  def destroy
    authorize @boat
    @boat.destroy
    redirect_to dashboard_owner_path
  end

  private

  def set_boat
    @boat = Boat.find(params[:id])
  end

  def boat_params
    params.require(:boat).permit(:name, :address, :description, :stars, :user_id, :category, :model, :capacity, :price, :photo)
  end
end
