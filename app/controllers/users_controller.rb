class UsersController < ApplicationController

  def create
    @user = User.create
    redirect_to @user
  end

  def show
    @user = User.find_by_token(params[:token])
    render "pages/index"
  end

end
