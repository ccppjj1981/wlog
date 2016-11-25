class Admin::PostsController < ApplicationController
  def convert_markdown
    @post = Post.find(params[:post_id])
    render plain: Post.render_html(@post.text || "")
  end

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end
  def srj_convert
    @post = Post.find(params[:id])
    @mkdown_txt = Post.render_html(@post.text || "")
    respond_to do |format|
      format.js
    end
  end
  def edit
    @post = Post.find(params[:id])
  end

  def show
    @post = Post.find(params[:id])
    @mkdown_txt = Post.render_html(@post.text || "")
    #render plain: Post.render_html(@post.text || "")
  end

  def update
    @post = Post.find(params[:id])
    Rails.logger.info("update=============#{params[:text]}")
    if @post.update(article_params)
      redirect_to @post
    else
      render 'edit'
    end
  end

  def create
    @post = Post.new(article_params)
    if @post.save
      #redirect_to @post
      redirect_to admin_posts_path
    else
      render 'new'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to admin_posts_path
  end

  private
  def article_params
    params.require(:post).permit("title", "text")
  end
end
