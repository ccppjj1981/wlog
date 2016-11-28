class BlogsController < ApplicationController
  def index
    @newest = Post.order(created_at: :desc).first
    @recent = Post.order(created_at: :desc).to_a[1..3]
    respond_to do |format|
      format.html
      format.json
    end
  end
end
