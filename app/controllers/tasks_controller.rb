class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  
  def index
    @tasks = Task.all;
  end
  
  def show
  end
  
  def new
    @task = Task.new;
  end

  def create
    @task = Task.new(task_params);
    
    if @task.save
      flash[:success] = 'タスクを追加しました';
      redirect_to @task;
    else
      flash.now[:danger] = 'タスクの追加に失敗しました';
      render :new;
    end
  end

  def edit
  end
  
  def update
    if @task.update(task_params)
      flash[:success] = 'タスクを修正しました';
      redirect_to @task;
    else
      flash.now[:danger] = 'タスクの修正に失敗しました';
      render :edit;
    end
  end
  
  def destroy
    @task.destroy;
    flash[:success] = 'タスクを削除しました';
    redirect_to tasks_url;
  end
  
  
  private
  # 以降privateメンバ
  
  
  # 指定idのtaskを取得
  def set_task
    @task = Task.find(params[:id]);
  end
  
  # task の Strong Parameter
  def task_params
    params.require(:task).permit(:content);
  end
  
end
