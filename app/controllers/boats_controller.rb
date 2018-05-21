class BoatsController < ApplicationController
  before_action :set_boat, only: [:show, :edit, :update, :destroy]

  def index
    @boats = Boat.all
  end

  def show
  end

  def new
    @boat = Boat.new
  end

  def edit
  end

  def create
    @boat = Boat.new(boat_params)
    @boat.user = current_user
    @boat.save!
    if @boat.save
      redirect_to boat_path(@boat)
    else
      render :new
    end
  end

  def update
    @boat.update(boat_params)
    if @boat.update(boat_params)
      redirect_to boat_path(@boat)
    else
      render :edit
    end
  end

  def destroy
    @boat.destroy
    redirect_to boats_path(@boat)
  end

  private

    def set_boat
      @boat = Boat.find(params[:id])
    end

    def boat_params
      params.require(:boat).permit(:name, :address, :description, :stars, :user_id, :category, :model, :capacity, :price)
    end
end
