class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :format_time
  helper_method :admin_username
  def format_time(time)
    time.strftime("%Y-%m-%d %H:%M")
  end
  protected
  def admin_username
    session[:login] && ENV['ADMIN_USER']
  end
end
