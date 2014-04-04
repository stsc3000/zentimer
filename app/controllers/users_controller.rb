class UsersController < ApplicationController

  def create
    @user = User.create
    render json: { url: user_url(@user.token) }
  end

  def show
    @user = current_user!
    respond_to do |format|
      format.html { render "pages/index" }
      format.json { render json: @user }
    end
  end

  def update
    @user = current_user!
    @user.update_attributes user_parameters

    respond_to do |format|
      format.json { render json: @user }
    end

  end

  private

  def user_parameters
    set_array_for_nil(:tags)
    set_array_for_nil(:projects)
    params[:user][:notification_settings] = params[:user][:notificationSettings] if params[:user][:notificationSettings]
    params[:user].delete :notificationSettings if params[:user][:notificationSettings]
    params.require(:user).permit(tags: [], projects: [], notification_settings: [ :enableDesktopNotification, :notificationInterval ])
  end

  def set_array_for_nil(key)
    if params[:user].has_key?(key) && !params[:user][key]
      params[:user][key] = []
    end
  end


end
