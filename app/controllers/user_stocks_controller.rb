class UserStocksController < ApplicationController

  def create
    stock = Stock.new_lookup(params[:ticker])
    stock.save
    @user_stock = UserStock.create(user: current_user, stock: stock)
    flash[:notice] = "Stock #{stock.name} was successfully added to your portfolio"
    redirect_to my_portfolio_path
  end

  def destroy
    stock = Stock.find(params[:id])
    user_stock = UserStock.where(user_id: current_user.id, stock_id: stock.id).first
    user_stock.destroy 
    # current_user.stocks.delete(stock)
    flash[:notice] = "#{stock.ticker} was successfully removed from portfolio"
    redirect_to my_portfolio_path
  end

end
