class Api::V1::CuisinesController < Api::V1::ApplicationController
  def index
    @cuisines = Cuisine.all
    if @cuisines.any?
      render json: @cuisines
    else
      render json: { message: t('errors.messages.cuisine_not_found') },
             status: :not_found
    end
  end
end
