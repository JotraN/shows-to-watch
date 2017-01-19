class StaticPagesController < ApplicationController
  def download
    render template: "static_pages/download"
  end
end
