class Api::TasksController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_task, only: [ :show, :update, :destroy ]

  # タスクを全件取得する
  # タスクが存在しない場合は存在しない旨をメッセージを返す
  # @return [Array<Task>] タスク情報一覧
  def index
    tasks = Task.all
    if tasks.empty?
      render json: { status: "OK", result: "タスクはありません" }, status: :ok
      return
    end
    render json: { status: "OK", result: tasks }, status: :ok
  end

  # IDを指定してタスクを取得する
  # そのIDに対応するタスクが存在しない場合は存在しない旨をメッセージを返す
  # @return [Task] タスク情報
  def show
    render json: { status: "OK", result: @task }, status: :ok
  end

  # 受け取った値から新規タスクを作成する
  # @param task_params [ActionController::Parameters] タスク名、説明、期日を含んだパラメータ
  # @return [Hash] 作成したタスク情報
  # @return [Hash] バリデーションエラー:エラーメッセージ
  def create
    task = Task.create(task_params)
    if task.persisted?
      render json: { status: "OK", result: task }, status: :created
    else
      error_handling(task.errors.full_messages, :unprocessable_entity)
    end
  end

  def make_tasks
    result = {
      success: 0,
      successTask: [],
      defeat: 0,
      defeatTask: []
    }

    tasks_params[:tasks].each do |one|
      one[:user_id] = tasks_params[:user_id]
      task = Task.create(one)
      if task.persisted?
        result[:success] += 1
        result[:successTask] << one
      else
        result[:defeat] += 1
        result[:defeatTask] << one
      end
    end
    render json: result, status: :created
  end

  # IDで指定したタスクの情報を更新する
  # そのIDに対応するタスクが存在しない場合は存在しない旨をメッセージを返す
  # @param task_params [ActionController::Parameters] タスク名、説明、期日を含んだパラメータ
  # @return [Hash] 更新したタスク情報
  # @return [Hash] バリデーションエラー:エラーメッセージ
  def update
    if @task.update(task_params)
      render json: { status: "OK", result: @task }, status: :ok
      return
    end
    error_handling(@task.errors.full_messages, :unprocessable_entity)
  end

  # IDで指定したタスクを削除する
  # そのIDに対応するタスクが存在しない場合は存在しない旨をメッセージを返す
  # @return [Hash] 削除したタスク情報 { status: "OK", result: Task }
  def destroy
    task = @task.destroy
    render json: { status: "OK", result: task }, status: :ok
  end

  # 最も新しいタスクを削除する
  # タスクが存在しない場合は存在しない旨をメッセージを返す
  # @return [Hash] 削除したタスク情報 { status: "OK", result: Task }
  def delete_recently_task
    task = Task.order(created_at: :desc).first
    if task.nil?
      render json: { status: "OK", result: "タスクが1つもありません" }, status: :ok
      return
    end
    task.destroy
    render json: { status: "OK", result: task }, status: :ok
  end

  private
  def task_params
    params.require(:task).permit(:title, :description, :due_date, :user_id)
  end

  def tasks_params
    params.permit(:user_id, task: {}, tasks: [ :title, :description, :due_date, :user_id ])
  end

  def set_task
    @task = Task.find_by(id: params[:id])
    render json: { status: "OK", result: "[ID:#{params[:id]}]そのタスクは見つかりません" }, status: :ok if @task.nil?
  end

  def error_handling(error_message, status)
    render json: { status: "NG", errors: error_message }, status: status
  end
end
