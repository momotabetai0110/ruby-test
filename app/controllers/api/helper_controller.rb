class Api::HelperController < ApplicationController
  # CSRF対策
  protect_from_forgery with: :null_session

  # 共通エラーハンドリング
  rescue_from PG::ConnectionBad, with: :database_error_handling
  rescue_from ActionController::ParameterMissing, with: :parameter_error_handling
  rescue_from ActiveRecord::StatementInvalid, with: :sql_error_handling
  rescue_from StandardError, with: :standard_error_handling

  def database_error_handling(exception)
    render json: { status: "NG", errors: [ "データベースに接続できません" ] }, status: :service_unavailable
  end

  def parameter_error_handling(exception)
    render json: { status: "NG", errors: [ "パラメータが不足しています:#{exception.param}"  ] }, status: :bad_request
  end

  def sql_error_handling(exception)
    render json: { status: "NG", errors: [ "SQLが不正です:#{ exception.message}" ] }, status: :unprocessable_entity
  end

  def standard_error_handling(exception)
    render json: { status: "NG", errors: [ "予期せぬエラー#{ exception.message}" ] }, status: :internal_server_error
  end

  def error_handling(error_message, status)
    render json: { status: "NG", errors: error_message }, status: status
  end
end
