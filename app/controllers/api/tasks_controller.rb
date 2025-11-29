class Api::TasksController < ApplicationController
  protect_from_forgery with: :null_session
  def index
    tasks = Task.all
    if tasks.empty?
      render json: { status: "OK", result: "タスクはありません" }, status: :ok
      return
    end
    render json: { status: "OK", result: tasks }, status: :ok
  end

  def show
    task = Task.find_by(id: params[:id])
    id =  params[:id]
    if task.nil?
      render json: { status: "OK", result: "[ID:#{id}]そのタスクは見つかりません" }, status: :ok
      return
    end
    render json: { status: "OK", result: task }, status: :ok
  end

  def create
    task = Task.create(task_params)
    render json: { status: "OK", result: task }, status: :ok
  end

  def update
    task = Task.find_by(id: params[:id])
    if task.nil?
      render json: { status: "OK", result: "[ID:#{params[:id]}]更新するタスクが見つかりません" }
      return
    end
    task.update(task_params)
    render json: { status: "OK", result: task }, status: :ok
  end

  def destroy
    task = Task.find_by(id: params[:id])
    if task.nil?
      render json: { status: "OK", result: "[ID:#{params[:id]}] 削除するタスクが見つかりません" }
      return
    end
    task = task.destroy
    render json: { status: "OK", result: task }, status: :ok
  end

  def delete_recently_task
    task = Task.order(created_at: :desc).first
    if task.nil?
      render json: { status: "OK", result: "タスクが1つもありません" }, status: :ok
      return
    end
    result = task.destroy
    render json: result, status: :ok
  end

  private
  def task_params
    params.require(:task).permit(:title, :description, :due_date)
  end
end
