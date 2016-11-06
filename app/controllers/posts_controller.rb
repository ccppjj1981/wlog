class PostsController < ApplicationController
  http_basic_authenticate_with name: "cpj", password: "cpj",
   except: [:index, :show]

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
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
    @post = Post.new(article_params)
    if @post.save
      redirect_to @post
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
    params.require(:post).permit(:title, :text)
  end
end
