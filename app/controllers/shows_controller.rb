require 'tvdb_client'

class ShowsController < ApplicationController
  before_action :set_show, only: [:show, :edit, :update, :destroy, 
                                  :search, :update_tvdb]
  before_action :authenticate_user!, except: [:show, :index]
  before_action :authenticate_admin!, except: [:show, :index]

  def index
    @shows = Show.all
  end

  def show
    if @show.tvdb_id
      redirect_to "http://thetvdb.com/?tab=series&id=#{ @show.tvdb_id }"
    else
      redirect_to search_show_url(@show), notice: 'Set a tvdb id.'
    end
  end

  def new
    @show = Show.new
  end

  def edit
  end

  def create
    @show = Show.new(show_params)

    respond_to do |format|
      if @show.save
        if @show.tvdb_id
          format.html { redirect_to shows_url, notice: 'Show was successfully created.' }
          format.json { render shows_url, status: :created, location: @show }
        else
          format.html { redirect_to search_show_url(@show), notice: 'Set a tvdb id.' }
        end
      else
        format.html { render :new }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @show.update(show_params)
        if @show.tvdb_id
          format.html { redirect_to shows_url, notice: 'Show was successfully updated.' }
          format.json { render shows_url, status: :ok, location: @show }
        else
          format.html { redirect_to search_show_url(@show), notice: 'Set a tvdb id.' }
        end
      else
        format.html { render :edit }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @show.destroy
    respond_to do |format|
      format.html { redirect_to shows_url, notice: 'Show was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search
    client = TvdbClient.new(Rails.application.secrets.TVDB_KEY)
    client.authenticate
    begin
      @possible_shows = client.search(@show.name)
    # TODO Let the user manually enter an id.
    rescue ArgumentError
      redirect_to edit_show_url(@show), alert: "Show not found at the TVDB."
    end
  end

  def update_tvdb
    respond_to do |format|
      if @show.update(show_params)
        # TODO Check if tvdb_id is json.
        tvdb_data = JSON.parse(@show.tvdb_id)
        @show.tvdb_id = tvdb_data["id"]
        @show.name = tvdb_data["seriesName"]
        @show.banner = tvdb_data["banner"]
        @show.save
        format.html { redirect_to shows_url, notice: "TVDB info was successfully set." }
        format.json { render shows_url, status: :ok, location: @show }
      else
        format.html { render :edit }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_show
      @show = Show.find(params[:id])
    end

    def show_params
      params.require(:show).permit(:tvdb_id, :name, :season, :episode, :banner, :completed)
    end

    def authenticate_admin!
      if not current_user.admin?
        redirect_to shows_url, alert: "Only admins can do that."
        return
      end
    end
end
