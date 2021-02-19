class CuisinesController < ApplicationController
  before_action :set_cuisine, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :user_admin?, only: %i[new create edit update destroy]
  def new
    @cuisine = Cuisine.new
  end

  def create
    @cuisine = Cuisine.new(cuisine_params)
    if @cuisine.save
      redirect_to @cuisine
    else
      render :new
    end
  end

  def edit; end

  def update
    if @cuisine.update(cuisine_params)
      redirect_to @cuisine
    else
      render :edit
    end
  end

  def destroy
    @cuisine.destroy
    redirect_to root_path, alert: 'Cozinha excluída com sucesso'
  end

  def show; end

  private

  def cuisine_params
    params.require(:cuisine).permit(:name)
  end

  def set_cuisine
    @cuisine = Cuisine.find(params[:id])
  end
end
