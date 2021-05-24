class HomeController < ApplicationController
  def index
  end

  def parse_url
    result = RestClient.get(params[:url])
    render json: result
  end

  def email
  end
  
end
