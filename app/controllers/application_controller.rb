# coidng: utf-8

class ApplicationController < ActionController::Base
  include TheRole::Requires

  protect_from_forgery

  def access_denied
    render text: 'access_denied: requires an role' and return
  end


  helper_method :current_user_session, :current_user

  private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  # ログインが必要なページに対する処理
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  # ログアウトが必要なページに対する処理
  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      return false
    end
  end

  # ログイン/ログアウトの処理の前にいたページの情報を保存
  def store_location
    session[:return_to] = request.fullpath
  end

  # 処理が終わった後に戻るページを返す
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  alias_method :login_required, :require_user
  alias_method :role_access_denied, :access_denied
end
