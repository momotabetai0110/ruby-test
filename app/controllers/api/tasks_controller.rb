class Api::TasksController < ApplicationController
  protect_from_forgery with: :null_session

  # タスクを全件取得する
  # タスクが存在しない場合はメッセージを返す
  # @return [Array<Task>] タスク情報一覧
  # @return [Hash] タスクが存在しない場合 { status: "OK", result: "タスクはありません" }
  def index
    tasks = Task.all
    if tasks.empty?
      render json: { status: "OK", result: "タスクはありません" }, status: :ok
      return
    end
    render json: { status: "OK", result: tasks }, status: :ok
  end

  # IDを指定してタスクを取得する
  # そのIDに対応するタスクが存在しない場合はメッセージを返す
  # @return [Task] タスク情報
  # @return [Hash] タスクが存在しない場合 { status: "OK", result: "{ID}そのタスクはありません" }
  def show
    task = Task.find_by(id: params[:id])
    id =  params[:id]
    if task.nil?
      render json: { status: "OK", result: "[ID:#{id}]そのタスクは見つかりません" }, status: :ok
      return
    end
    render json: { status: "OK", result: task }, status: :ok
  end

  # 受け取った値から新規タスクを作成する
  # @param task_params [ActionController::Parameters] タスク名、説明、期日を含んだパラメータ
  # @return [Hash] 作成したタスク情報
  def create
    task = Task.create(task_params)
    render json: { status: "OK", result: task }, status: :ok
  end

  # IDで指定したタスクの情報を更新する
  # そのIDに対応するタスクが存在しない場合はメッセージを返す
  # @param task_params [ActionController::Parameters] タスク名、説明、期日を含んだパラメータ
  # @return [Hash] 更新したタスク情報
  # @return [Hash] タスクが存在しない場合 { status: "OK", result: "{ID}更新するタスクはありません" }
  def update
    task = Task.find_by(id: params[:id])
    if task.nil?
      render json: { status: "OK", result: "[ID:#{params[:id]}]更新するタスクが見つかりません" }
      return
    end
    task.update(task_params)
    render json: { status: "OK", result: task }, status: :ok
  end

  # IDで指定したタスクを削除する
  # そのIDに対応するタスクが存在しない場合はメッセージを返す
  # @param task_params [ActionController::Parameters] タスク名、説明、期日を含んだパラメータ
  # @return [Hash] 削除したタスク情報 { status: "OK", result: Task }
  # @return [Hash] タスクが存在しない場合 { status: "OK", result: "{ID}削除するタスクはありません" }
  def destroy
    task = Task.find_by(id: params[:id])
    if task.nil?
      render json: { status: "OK", result: "[ID:#{params[:id]}] 削除するタスクが見つかりません" }
      return
    end
    task = task.destroy
    render json: { status: "OK", result: task }, status: :ok
  end

  # 最も新しいタスクを削除する
  # @return [Hash] 削除したタスク情報 { status: "OK", result: Task }
  # @return [Hash] タスクが存在しない場合 { status: "OK", result: "タスクが1つもありません" }
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
    params.require(:task).permit(:title, :description, :due_date)
  end
end
