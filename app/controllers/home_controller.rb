class HomeController < ApplicationController
  def index
  end

  def parse_url
    result = RestClient.get(params[:url])
    render json: result
  end
end
