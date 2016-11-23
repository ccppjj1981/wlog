class Admin::SessionsController < ApplicationController
  def new
  end
  def create
    Rails.logger.info("params[:username]==#{params[:username]}")
    Rails.logger.info("params[:password]===#{params[:password]}")
    if ENV['ADMIN_USER'].blank?
      Rails.logger.info("==1")
      flash.now[:alert] = t('admin.session.no_configuration')
      render :new
    elsif ENV['ADMIN_USER'] != params[:username]
      Rails.logger.info("==2")
      flash.now[:alert] = t('admin.session.username_error')
      render :new
    elsif ENV['ADMIN_PASSWORD'] != params[:password]
      Rails.logger.info("==3")
      flash.now[:alert] = t('admin.session.password_error')
      render :new
    else
      flash[:notice] = t('admin.session.login_success')
      session[:login] = true
      Rails.logger.info("admin_root_path")
      redirect_to admin_root_path
    end
  end
end
