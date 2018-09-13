class Notification::SlackService < ApplicationService
  DEFAULT_CHANNEL = "#notification"

  def initialize
    @enable_to_send = Rails.env.production?
  end

  def call(text, username, channel)
    if @enable_to_send
      Slack.chat_postMessage text: text, username: username, channel: channel
    end
  end

  def self.unexpected_error(error, params, request, user)
    message  = "500 Internal Server Error:\n"
    message += "==============================\n"
    message += error.message + "\n"
    message += error.backtrace_locations.first.to_s + "\n" if error.backtrace_locations.present?
    message += "==============================\n"
    if user.present?
      message += "User ID: #{user.id}\n"
      message += "User Name: #{user.name}\n"
    else
      message += "Unlogined User\n"
    end
    message += "[#{request.method}] #{request.url}\n"
    message += "[Params]\n"
    params.each {|k, v| message += "#{k} : #{v}\n" }
    message += "==============================\n"

    self.new.call(message, "Error Report", DEFAULT_CHANNEL)
  end
end
