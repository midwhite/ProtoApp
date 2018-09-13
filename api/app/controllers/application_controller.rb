class ApplicationController < ActionController::API
  def check
    render json: { success: true }
  end
end
