class PostsController < ApplicationController
  load_and_authorize_resource

  def index
    @posts = Post.includes(:comments).where(author_id: params[:user_id])
    @user = User.find(params[:user_id])
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.author
  end

  def new
    @post = Post.new
  end

  def create
    puts 'Current User'

    @post = Post.new(post_params)
    @post.author = current_user

    respond_to do |_format|
      if @post.save
        redirect_to user_posts_path(current_user)
      else
        render :new
      end
    end
  end

  def destroy
    @post = Post.find(params[:id])

    if @post.destroy
      redirect_to user_posts_path(current_user), notice: 'Post deleted successfully'
    else
      flash.new[:alert] = @post.errors.full_messages.first if @post.errors.any?
      render :show, status: 400
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
