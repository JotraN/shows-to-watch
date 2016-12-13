require 'tvdb_client'

class Api::ShowsController < Api::ApiController
  acts_as_token_authentication_handler_for User, 
    except: [:show, :index, :abandoned, :completed, :in_progress]
  before_action :set_show, only: [:show, :edit, :update, :destroy, 
                                  :search, :update_tvdb]
  before_action :authenticate_user!, except: [:show, :index, :abandoned, 
                                              :completed, :in_progress]
  before_action :authenticate_admin!, except: [:show, :index, :abandoned, 
                                               :completed, :in_progress]

  def index
    @shows = Show.all
    render_json_only(@shows)
  end

  def abandoned
    @shows = Show.where(abandoned: true)
    render_json_only(@shows)
  end

  def completed
    @shows = Show.where(completed: true)
    render_json_only(@shows)
  end

  def in_progress
    @shows = Show.where(abandoned: false, completed: false)
    render_json_only(@shows)
  end

  def create
    @show = Show.new(show_params)
    if @show.save
      if @show.tvdb_id
        render_json_only(@show)
      else
        redirect_to search_api_show_url(@show)
      end
    else
      render_json_only(@show.errors)
    end
  end

  def search
    client = TvdbClient.new(Rails.application.secrets.TVDB_KEY)
    client.authenticate
    begin
      @possible_shows = client.search(@show.name)
      render_json_only(@possible_shows)
    rescue ArgumentError
      render_json_only({ error: "Show not found at the TVDB" })
    end
  end

  def update
    if @show.update(show_params)
      if @show.tvdb_id
        render_json_only(@show)
      else
        redirect_to search_api_show_url(@show)
      end
    else
      render_json_only(@show.errors)
    end
  end

  def destroy
    @show.destroy
    render_json_only({ success: "Show was deleted." })
  end

  private
    def set_show
      @show = Show.find(params[:id])
    end

    def show_params
      params.require(:show).permit(:tvdb_id, :name, :season, :episode, :banner, 
                                   :completed, :abandoned)
    end

    def authenticate_admin!
      if not current_user.admin?
        render_json_only(error: "Admin action only.")
        return
      end
    end
end
