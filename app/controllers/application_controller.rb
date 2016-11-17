class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :format_time
  def format_time(time)
    time.strftime("%Y-%m-%d %H:%M")
  end
end
