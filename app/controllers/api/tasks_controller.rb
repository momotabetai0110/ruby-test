class Api::TasksController < ApplicationController
  protect_from_forgery with: :null_session
  def index
    tasks = Task.all
    render json: tasks
  end

  def show
    task = Task.find(params[:id])
    render json: task
  end

  def create
    Task.create(task_params)
    render json: { status: "OK" }, status: :ok
  end

  def update
    task = Task.find(params[:id])
    task.update(task_params)
    render json: { status: "OK" }, status: :ok
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    render json: { status: "OK" }, status: :ok
  end

  def delete_recently_task
    task = Task.order(created_at: :desc).first
    result = task.destroy
    render json: result, status: :ok
  end

  private
  def task_params
    params.require(:task).permit(:title, :description, :due_date)
  end
end
