class TasksController < ApplicationController

  # 操作は必ずログイン済み前提とする
  before_action :require_user_logged_in;
  
  # ログインユーザが一致するかチェックする
  before_action :correct_user, only: [:show, :edit, :update, :destroy];
  
  # 事前に指定されたidのタスクを@taskにセット
  before_action :set_task, only: [:show, :edit, :update, :destroy];
  
  
  def index
    
    @form = SearchForm.new(search_form_params);
    
    @user = current_user;
    @states = State.all;
    
    if @form.tag.blank?
      @tasks = @user.tasks;
    else
      tag = Tag.find_by(name: @form.tag);
      if tag
        @tasks = @user.tasks.where(id: Relationship.where(tag_id: tag.id).select(:task_id));
      else
        @tasks = Task.none;
      end
    end
    
    unless @form.keyword.blank?
      case @form.target
        when '1'
          @tasks = @tasks.search(['title'], @form.keyword);
        when '2'
          @tasks = @tasks.search(['content'], @form.keyword);
        when '3'
          @tasks = @tasks.search(['title', 'content'], @form.keyword);
      end
    end
    
    @tasks = @tasks.joins(:state).preload(:state);
    remained_tasks = @tasks.where('states.is_effective = true');
    @count_remained_tasks = remained_tasks.count;
    
    if @form.tab.blank?
      @tasks = remained_tasks;
    elsif @form.tab != '0'
      @tasks = @tasks.where('state_id = ?', @form.tab);
    end
    @tasks = @tasks.order('updated_at DESC').page(params[:page]).per(20).preload(:state, :tags);
    
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
    @task.add_tags(make_tag_names);
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
    @task.amend_tags(make_tag_names);
    
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
  
  # タグの文字列を解析してタグ名の配列を生成
  # @param tag_str: タグ名（空白区切り）
  def make_tag_names
    task_tags = params.require(:task).permit(:tags)[:tags];
    if task_tags.blank?
      return [];
    else
      return task_tags.split(/[ ,　]/).reject(&:blank?);
    end
  end
  
  # Task の Strong Parameter
  def task_params
    params.require(:task).permit(:state_id, :title, :content);
  end
  
  # SearchForm の Strong Parameter
  def search_form_params
    
    if params[:search_form].blank?
      {
        tab: nil,
        tag: nil,
        target: 3,
        keyword: nil
      }
    else
      params.require(:search_form).permit(:tab, :tag, :target, :keyword);
    end
  end
end
