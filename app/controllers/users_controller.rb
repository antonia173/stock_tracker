class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @tracked_stocks = @user.stocks 
  end 

  def my_portfolio
    @user = current_user
    @tracked_stocks = current_user.stocks # devise helper
  end

  def my_friends
    @friends = current_user.friends
  end

  def search
    if params[:friend].present?
      @friends = User.search(params[:friend])
      @friends = current_user.except_current_user(@friends)
      if @friends.any?
        respond_to do |format|
          format.js { render partial: 'users/friends_result' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "Couldn't find user"
          format.js { render partial: 'users/friends_result' }
        end
      end
    else 
      respond_to do |format|
        flash.now[:alert] = "Please enter a friend name or email to search"
        format.js { render partial: 'users/friends_result' }
      end
    end
  end

end
