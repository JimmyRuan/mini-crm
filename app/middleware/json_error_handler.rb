module RailsCopperApi
  class JsonErrorHandler
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    rescue StandardError => e
      status = error_status(e)
      error_response = build_error_response(e, status)
      
      # Log the error
      Rails.logger.error("Error: #{e.class.name}")
      Rails.logger.error("Message: #{e.message}")
      Rails.logger.error("Backtrace: #{e.backtrace.join("\n")}") if Rails.env.development?

      [status, { 'Content-Type' => 'application/json' }, [error_response.to_json]]
    end

    private

    def error_status(error)
      case error
      when ActiveRecord::RecordNotFound
        404
      when ActionController::ParameterMissing, ActionController::UnpermittedParameters
        400
      when ActionController::InvalidAuthenticityToken
        422
      else
        500
      end
    end

    def build_error_response(error, status)
      if Rails.env.development?
        {
          error: error.class.name,
          message: error.message,
          backtrace: error.backtrace
        }
      else
        {
          error: status == 500 ? 'Internal Server Error' : error.class.name,
          message: status == 500 ? 'Something went wrong. Please try again later.' : error.message
        }
      end
    end
  end
end 