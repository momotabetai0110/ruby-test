class TasksController < ApplicationController
  def index
    puts "start"
    @tasks = Task.all

    if params[:search].present?
      @tasks = @tasks.where("title LIKE ? OR description LIKE ?",
        "%#{params[:search]}%",
        "%#{params[:search]}%")
    end

    case params[:sort]
    when "title"
      @tasks = @tasks.order(:title)
    when "due"
      @tasks = @tasks.order(:due_date)
    else
      @tasks = @tasks.order(created_at: :desc)
    end
  end

  def new
    @task = Task.new
  end

  def create
    Task.create(task_params)
    redirect_to tasks_path
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    task = Task.find(params[:id])
    task.update(task_params)
    redirect_to tasks_path
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    redirect_to tasks_path
  end

  private

def task_params
  params.require(:task).permit(:title, :description, :due_date)
end
end
