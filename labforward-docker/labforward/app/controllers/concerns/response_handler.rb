module ResponseHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern

  included do
    rescue_from Exception, with: :render_500
    rescue_from AbstractController::ActionNotFound, with: :render_400
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
  end

  %w[400 500].each do |status_code|
    define_method("render_#{status_code}") do |exception|
      logger.error "[Exception]: #{exception}"
      logger.error "[Backtrace]: #{exception.backtrace.join("\n")}"
      send_error(status_code)
    end
  end

  %w[401 404 422].each do |status_code|
    define_method("render_#{status_code}") do |message=''|
      send_error(status_code, message)
    end
  end

  %w[200 201].each do |status_code|
    define_method("render_#{status_code}") do |json_response={}|
      send_success(status_code, json_response)
    end
  end

  private

  def send_error(status=500, message='')
    render json: { error: { code: status, message: message } },
           status: status
  end

  def send_success(status=:ok, json_response={})
    render json: json_response, status: status
  end
end
