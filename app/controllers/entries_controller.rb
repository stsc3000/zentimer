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

  def filter
    @entries = current_user!.entries.filter(filter_params)
    render json: @entries
  end

  private

  def entry_params
    params.require(:entry).permit!
  end

  def filter_params
    filtered = params.require(:filters).permit between: [:start_date, :end_date],
                                   by_tags: [],
                                   by_projects: []

    filtered[:between][:start_date] = Time.parse filtered[:between][:start_date] if filtered[:between].try :[], :start_date
    filtered[:between][:end_date] = Time.parse filtered[:between][:end_date] if filtered[:between].try :[], :end_date

    filtered
  end
end
