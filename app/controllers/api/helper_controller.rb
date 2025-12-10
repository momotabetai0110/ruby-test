class Api::HelperController < ApplicationController
  # CSRF対策
  protect_from_forgery with: :null_session

  # 共通エラーハンドリング
  rescue_from PG::ConnectionBad, with: :database_error_handling
  rescue_from ActionController::ParameterMissing, with: :parameter_error_handling
  rescue_from ActiveRecord::StatementInvalid, with: :sql_error_handling
  rescue_from StandardError, with: :standard_error_handling

  def database_error_handling(exception)
    log_error("Database Connection Error", exception)
    render json: { status: "NG", errors: [ "データベースに接続できません" ] }, status: :service_unavailable
  end

  def parameter_error_handling(exception)
    log_error("Parameter Missing Error", exception)
    render json: { status: "NG", errors: [ "パラメータが不足しています" ] }, status: :bad_request
  end

  def sql_error_handling(exception)
    log_error("SQL Error", exception)
    render json: { status: "NG", errors: [ "データベースエラーが発生しました" ] }, status: :unprocessable_entity
  end

  def standard_error_handling(exception)
    log_error("Standard Error", exception)
    render json: { status: "NG", errors: [ "予期せぬエラーが発生しました" ] }, status: :internal_server_error
  end

  def error_handling(error_message, status)
    Rails.logger.error("Validation/Business Logic Error: #{error_message.is_a?(Array) ? error_message.inspect : error_message}")
    Rails.logger.error("Status: #{status}")
    render json: { status: "NG", errors: error_message }, status: status
  end

  private

  def log_error(error_type, error_info)
    Rails.logger.error("#{error_type}: #{error_info.message}")
    Rails.logger.error(error_info.backtrace.join("\n")) if error_info.respond_to?(:backtrace)
  end
end
