class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :logged_in, only: %i[ feed new_post create_new_post profile follow_user unfollow_user like_post unlike_post ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def main
    @user = User.new
    session[:user_id] = nil
  end

  def login
    @user = User.find_by(email: user_params[:email])
    if @user == nil
      redirect_to main_url, alert: "Email not existed"
    else
      if @user.authenticate(user_params[:password])
        redirect_to feed_url
        session[:user_id] = @user.id
      else
        redirect_to main_url, alert: "Email or Password incorrect"
      end
    end
  end

  def register
    @user = User.new
  end

  def create_new_user
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to main_url, notice: "User was successfully created." }
      else
        format.html { render :register, status: :unprocessable_entity }
      end
    end
  end

  def feed
    # @user = User.find(session[:user_id])
    # a = []
    # Follow.where(follower_id: session[:user_id]).each{|f| User.find(f.followee_id).posts.each{|p| a<<p}}
    # @a = a.sort_by(&:created_at).reverse

    # ids = Follow.where(follower_id: session[:user_id]).pluck ('followee_id')
    # @a = Post.where(user_id: ids).order('created_at DESC')

    @posts = User.find(session[:user_id]).get_feed_post
    @post = Post.new
    session[:current_url] = request.original_url
  end

  def new_post
    @post = Post.new
  end

  def create_new_post
    @post = Post.new(msg: post_params[:msg],user_id: session[:user_id])

    respond_to do |format|
      if @post.save
        format.html { redirect_to feed_url, notice: "Post was successfully created." }
      else
        format.html { render :new_post, status: :unprocessable_entity }
      end
    end
  end

  def profile
    @user = User.find_by(name: params[:name])
    @posts = @user.get_profile_post

    @follow = Follow.new
    @post = Post.new

    @followed = Follow.find_by(follower_id: session[:user_id], followee_id: User.find_by(name: params[:name]))
    session[:current_url] = request.original_url
  end

  def follow_user
    Follow.create(follower_id: session[:user_id], followee_id: User.find_by(name: params[:name]).id)
    redirect_to profile_url(params[:name])
  end

  def unfollow_user
    Follow.find_by(follower_id: session[:user_id], followee_id: User.find_by(name: params[:name]).id).destroy
    redirect_to profile_url(params[:name])
  end

  def like_post
    Like.create(user_id: session[:user_id], post_id: params[:id])
    redirect_to session[:current_url]
  end

  def unlike_post
    Like.find_by(user_id: session[:user_id], post_id: params[:id]).destroy
    redirect_to session[:current_url]
  end

  private
    def logged_in
      if session[:user_id]
        return true
      else
        redirect_to main_url, notice: "Please login"
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def post_params
      params.require(:post).permit(:msg)
    end
end
