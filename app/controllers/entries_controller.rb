class EntriesController < ApplicationController
  def index
    @entries = current_user!.entries
    render json: @entries
  end

  def show
    @entry = current_user!.entries.find(params[:id])
    render json: @entry
  end

  def create
    @entry = current_user!.entries.create(entry_params)
    render json: @entry
  end

  def update
    @entry = current_user!.entries.find(params[:id])
    @entry.update entry_params
    render json: @entry
  end

  def destroy
    @entry = current_user!.entries.find(params[:id])
    @entry.destroy
    render json: { status: "success" }
  end

  def clear
    @entries = current_user!.entries.where("running is not true")
    @entries.destroy_all
    render json: { status: "success" }
  end

  private

  def entry_params
    params.require(:entry).permit!
  end
end
