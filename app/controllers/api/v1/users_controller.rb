class Api::V1::UsersController < Api::V1::ApplicationController
  before_action :authenticate_with_token!, only: %i[update destroy]

  def create
    user = User.new(user_params)

    if user.save
      render json: user, status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
    head :no_content
  end

  def show
    @user = User.find(params[:id])
    respond_with @user
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def update
    user = current_user

    if user.update(user_params)
      render json: user, status: :ok
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(%i[name email password city
                                    facebook twitter photo])
  end
end
