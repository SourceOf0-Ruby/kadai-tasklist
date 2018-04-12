class ApplicationController < ActionController::Base
  
  # CSRF対策
  # 参考:http://hakutoitoi.hatenablog.com/entry/2013/01/05/014857
  protect_from_forgery with: :exception
  
  # ログイン周りのメソッドを使用するためinclude
  include SessionsHelper;
  
  
  private
  
  # ログインしていない場合はログインページにリダイレクトする
  def require_user_logged_in
    unless logged_in?
      redirect_to login_url;
    end
  end
  
end
