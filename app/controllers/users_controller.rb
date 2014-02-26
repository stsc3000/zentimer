class UsersController < ApplicationController

  def create
    @user = User.create
    render json: { url: user_url(@user.token) }
  end

  def show
    @user = current_user
    respond_to do |format|
      format.html { render "pages/index" }
      format.json { render json: @user.to_json(only: [:entries, :tags, :projects]) }
    end
  end

  def update
    @user = current_user
    @user.update_attributes user_parameters

    respond_to do |format|
      format.json { render json: @user.to_json(only: [:entries, :tags, :projects]) }
    end

  end

  private

  def user_parameters
    set_array_for_nil(:tags)
    set_array_for_nil(:projects)
    params.require(:user).permit(tags: [], projects: [])
  end

  def set_array_for_nil(key)
    if params[:user].has_key?(key) && !params[:user][key]
      params[:user][key] = []
    end
  end


end
