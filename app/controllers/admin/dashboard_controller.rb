class Admin::DashboardController < ApplicationController
  layout 'layouts/admin'
  before_action :authericate_user!
  def index
    @posts_count = Post.all.size
    @comments_count = Comment.all.size
    #Rails.logger.info("posts_count=#{@posts_count}")
    #Rails.logger.info("comments_count=#{@comments_count}")
  end
end
