class UsersController < ApplicationController
  def new 
    @title = "Sign up"
    @user = User.new  # Create a new user object in the contructor
  end

  # This is the controller method which will locate and display a particular user
  def show
    @user = User.find(params[:id])
    @title = User.name
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!, I came all the way from the users controller"
      redirect_to @user
    else
      @title = "Sign up"
      @user.password = ""
      render 'new'
    end
  end
end
