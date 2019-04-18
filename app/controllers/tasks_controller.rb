class TasksController < ApplicationController

  # 操作は必ずログイン済み前提とする
  before_action :require_user_logged_in;
  
  # ログインユーザが一致するかチェックする
  before_action :correct_user, only: [:show, :edit, :update, :destroy];
  
  # 事前に指定されたidのタスクを@taskにセット
  before_action :set_task, only: [:show, :edit, :update, :destroy];
  
  def index
    
    @form = SearchForm.new(search_form_params);
    @tab = @form.tab;
    
    @user = current_user;
    @states = State.all;
    
    @tasks = @form.get_task(@user).joins(:state).preload(:state);
    remained_tasks = @tasks.where('states.is_effective = true');
    @count_remained_tasks = remained_tasks.count;
    
    if @tab.blank?
      @tasks = remained_tasks;
    elsif @tab != '0'
      @tasks = @tasks.where('state_id = ?', @tab);
    end
    @tasks = @tasks.order('updated_at DESC').page(params[:page]).per(20).preload(:state, :tags);
    
    set_tags
  end
  
  
  def show
    # Do nothing.
  end
  
  def new
    @user = current_user;
    @task = @user.tasks.build;
    @states = State.all;
    set_tags
  end

  def create
    @user = current_user;
    @task = @user.tasks.build(task_params);
    @states = State.all;
    
    if @task.save && @task.amend_tags
      flash[:success] = 'タスクを追加しました';
      redirect_to @task;
    else
      flash.now[:danger] = 'タスクの追加に失敗しました';
      set_tags
      render :new;
    end
  end

  def edit
    @states = State.all;
    set_tags
  end
  
  def update
    @states = State.all;
    
    if @task.update(task_params) && @task.amend_tags
      flash[:success] = 'タスクを修正しました';
      redirect_to @task;
    else
      flash.now[:danger] = 'タスクの修正に失敗しました';
      set_tags
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
  
  # tagの一覧を取得
  def set_tags
    @tags = Tag.where(id: Relationship.where(task_id: current_user.tasks.ids).select(:tag_id));
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
  
  # Task の Strong Parameter
  def task_params
    params.require(:task).permit(:state_id, :tags_str, :title, :content);
  end
  
  # SearchForm の Strong Parameter
  def search_form_params
    params.fetch(:search_form, {
      tab: nil,
      tag: nil,
      target: SearchForm.target_str_list[0][1],
      keyword: nil
    }).permit(:tab, :tag, :target, :keyword);
  end
end
