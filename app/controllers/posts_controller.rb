class PostsController < ApplicationController

  def preview
    Rails.logger.info("=============preview")
    render plain: Post.render_html(params[:text] || "")
  end

  def index
    @posts = Post.all
  end

  def new
    Rails.logger.info("=============new")
    @post = Post.new
  end
  def srj_convert
    @post = Post.find(params[:id])
    Rails.logger.info("=============#{@post.text}")
    @mkdown_txt = Post.render_html(@post.text || "")
    Rails.logger.info("============#{@mkdown_txt}")
    respond_to do |format|
      format.js
    end
  end
  def edit
    @post = Post.find(params[:id])
  end

  def show
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(article_params)
      redirect_to @post
    else
      render 'edit'
    end
  end

  def create
    Rails.logger.info("title=============#{params[:title]}")
    Rails.logger.info("text=============#{params[:text]}")
    @post = Post.new(params.permit(:title, :text))
    #@post = Post.new(article_params)
    if @post.save
      #redirect_to @post
      redirect_to posts_path
    else
      render 'new'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to posts_path
  end

  private
  def article_params
    params.require(:post).permit("title", "text")
  end
end
