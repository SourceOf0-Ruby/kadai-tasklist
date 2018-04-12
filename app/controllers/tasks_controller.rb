class TasksController < ApplicationController

  # 操作は必ずログイン済み前提とする
  before_action :require_user_logged_in;
  
  # ログインユーザが一致するかチェックする
  before_action :correct_user, only: [:show, :edit, :update, :destroy];
  
  # 事前に指定されたidのタスクを@taskにセット
  before_action :set_task, only: [:show, :edit, :update, :destroy];
  
  
  def index
    
    @user = current_user;
    @tasks = @user.tasks;
    remained_tasks = @tasks.joins(:state).where('states.is_effective = true');
    @count_remained_tasks = remained_tasks.count;
    
    @states = State.all;
    
    @tab = params[:tab];
    @target = params[:target];
    @keyword = params[:keyword];
    
    if @tab.blank?
      @tasks = remained_tasks;
    elsif @tab != '0'
      @tasks = @tasks.where('state_id = ?', @tab);
    end
    @tasks = @tasks.search(['title'], @keyword) if @target == '1';
    @tasks = @tasks.search(['content'], @keyword) if @target == '2';
    @tasks = @tasks.search(['title', 'content'], @keyword) if @target == '3';
    @tasks = @tasks.order('updated_at DESC').page(params[:page]).per(20);
    
  end
  
  
  def show
    # Do nothing.
  end
  
  def new
    @user = current_user;
    @task = @user.tasks.build;
    @states = State.all;
  end

  def create
    @user = current_user;
    @task = @user.tasks.build(task_params);
    @states = State.all;
    
    if @task.save
      flash[:success] = 'タスクを追加しました';
      redirect_to @task;
    else
      flash.now[:danger] = 'タスクの追加に失敗しました';
      render :new;
    end
  end

  def edit
    @states = State.all;
  end
  
  def update
    @states = State.all;
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
  
  # 操作を行うユーザのチェックを行う
  # 一致しなければルートへリダイレクト
  def correct_user
    # ログインユーザのタスクから該当するものを検索する
    task = current_user.tasks.find_by(id: params[:id]);
    unless task
      flash[:danger] = '操作を実行できませんでした。';
      redirect_to root_url;
    end
  end
  
  # task の Strong Parameter
  def task_params
    params.require(:task).permit(:state_id, :title, :content);
  end
  
end
