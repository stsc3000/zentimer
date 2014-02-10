class UsersController < ApplicationController

  def create
    @user = User.create
    render json: { url: user_url(@user.token) }
  end

  def show
    @user = current_user
    respond_to do |format|
      format.html { render "pages/index" }
      format.json { render json: @user.to_json(only: :entries) }
    end
  end

end
