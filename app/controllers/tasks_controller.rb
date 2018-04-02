class TasksController < ApplicationController

  # 操作は必ずログイン済み前提とする
  before_action :require_user_logged_in;
  
  # 投稿主とログインユーザが一致するかチェックする
  before_action :correct_user, only: [:show, :edit, :update, :destroy];
  
  # 事前に指定されたidのタスクを@taskにセット
  before_action :set_task, only: [:show, :edit, :update, :destroy];
  
  
  def index
    @user = current_user;
    @tasks = @user.tasks.order('updated_at DESC').page(params[:page]).per(10);
    count_remained_tasks(@user);
  end
  
  def show
    # Do nothing.
  end
  
  def new
    @user = current_user;
    @task = @user.tasks.build;
  end

  def create
    @user = current_user;
    @task = @user.tasks.build(task_params);
    
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
  
  # 操作を行う投稿主のチェックを行う
  # 一致しなければルートへリダイレクト
  def correct_user
    # ログインユーザの投稿記事から該当するものを検索する
    task = current_user.tasks.find_by(id: params[:id]);
    unless task
      flash[:danger] = '操作を実行できませんでした。';
      redirect_to root_url;
    end
  end
  
  # task の Strong Parameter
  def task_params
    params.require(:task).permit(:status, :title, :content);
  end
  
end
