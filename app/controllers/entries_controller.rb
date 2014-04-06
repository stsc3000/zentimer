class EntriesController < ApplicationController

  def index
    @entries = current_user!.entries.today_or_current
    render json: @entries
  end

  def show
    @entry = current_user!.entries.find(params[:id])
    render json: @entry
  end

  def create
    @entry = current_user!.entries.create(entry_params)
    force_only_one_current_entry(@entry)
    render json: @entry
  end

  def update
    @entry = current_user!.entries.find(params[:id])
    @entry.update entry_params
    force_only_one_current_entry(@entry)
    render json: @entry
  end

  def destroy
    @entry = current_user!.entries.find(params[:id])
    @entry.destroy
    render json: { status: "success" }
  end

  def clear
    @entries = current_user!.entries.where("running is not true").where(id: params[:ids])
    @entries.destroy_all
    render json: { status: "success" }
  end

  def filter
    @entries = current_user!.entries.filter(filter_params).includes(:tags)
    render json: @entries
  end

  def projects
    render json: { projects: current_user!.used_projects }
  end

  def tags
    render json: { tags: current_user!.used_tags }
  end

  private

  def force_only_one_current_entry(entry)
    Entry.force_only_one_current_entry(current_user, entry)
  end

  def entry_params
    params.require(:entry).permit!
  end

  def filter_params
    #Make this tighter once ready
    params.require(:query).permit!
  end
end
