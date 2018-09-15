class ApplicationController < ActionController::API
  rescue_from Exception, with: :unexpected_error                     if Rails.env.production?
  rescue_from ActionController::RoutingError, with: :not_found_error if Rails.env.production?
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error   if Rails.env.production?

  respond_to :json

  before_action :set_response_headers
  before_action :authenticate_user_from_token!, except: [:check, :not_found_error, :unexpected_error]

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

  private
  def set_response_headers
    response.headers["Access-Control-Allow-Headers"] = "Origin,Authorization,Accept,X-Requested-With,Content-Type"
  end

  def authenticate_user_from_token!
    # ログイン必須のアクションで利用
    auth_token = request.headers["Authorization"]

    if auth_token && auth_token.include?(":")
      authenticate_with_auth_token auth_token
    else
      authenticate_error
    end
  end

  def login_if_token_exists!
    # ログイン無しで閲覧できるアクションで利用
    auth_token = request.headers["Authorization"]

    if auth_token && auth_token.include?(":")
      authenticate_with_auth_token auth_token
    end
  end

  def authenticate_with_auth_token(auth_token)
    user = User.find_by(id: auth_token.split(':').first)

    if user && Devise.secure_compare("#{user.id}:#{user.access_token}", auth_token)
      sign_in :user, user, store: false
    else
      authenticate_error
    end
  end

  def authenticate_error
    return render status: :unauthorized, json: { errors: ['ユーザー認証エラーが発生しました。'] }
  end
end
