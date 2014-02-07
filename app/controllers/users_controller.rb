class UsersController < ApplicationController

  def create
    @user = User.create
    render json: { url: user_url(@user) }
  end

  def show
    @user = User.find_by_token(params[:token])
    render "pages/index"
  end

end
