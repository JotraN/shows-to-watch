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

  private
    def render_json_only(json)
      respond_to do |format|
        format.html { raise ActionController::RoutingError.new('Page Not Found') }
        format.json { render json: json }
      end
    end

    def set_show
      @show = Show.find(params[:id])
    end

    def show_params
      params.require(:show).permit(:tvdb_id, :name, :season, :episode, :banner, 
                                   :completed, :abandoned)
    end

    def authenticate_admin!
      if not current_user.admin?
        redirect_to shows_url, alert: "Only admins can do that."
        return
      end
    end
end
