class Api::ApiController < ActionController::Base
  protect_from_forgery with: :null_session

  def render_json_only(json)
    respond_to do |format|
      format.html { raise ActionController::RoutingError.new('Page Not Found') }
      format.json { render json: json }
    end
  end
end
