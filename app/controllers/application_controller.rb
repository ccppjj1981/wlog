class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :format_time
  helper_method :admin_username
  def format_time(time)
    time.strftime("%Y-%m-%d %H:%M")
  end
  protected
  def authericate_user!
    if ! session[:login]
      flash[:error] = '请先登录后台管理'
      cookies[:urlback] = request.original_url
      redirect_to new_admin_session_path
    end
  end
  def admin_username
    session[:login] && ENV['ADMIN_USER']
  end
end
