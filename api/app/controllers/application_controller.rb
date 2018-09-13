class ApplicationController < ActionController::API
  rescue_from Exception, with: :unexpected_error                     if Rails.env.production?
  rescue_from ActionController::RoutingError, with: :not_found_error if Rails.env.production?
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error   if Rails.env.production?

  def check
    render json: { success: true }
  end

  def not_found_error
    render status: 404, json: { errors: ["Not Found"] }
  end

  def unexpected_error(error)
    Notification::SlackService.unexpected_error(error, params, request, current_user)
    render status: 500, json: { errors: ["Unexpected Error"] }
  end
end
