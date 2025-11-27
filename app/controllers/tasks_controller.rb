class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def new
  end

  def show
  end

  def edit
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    redirect_to tasks_path,
  end
end
