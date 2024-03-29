class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  def stock_already_tracked?(ticker_symbol)
    self.stocks.where(ticker: ticker_symbol.upcase).exists?    
  end

  def under_stock_limit?
    stocks.count < 10
  end

  def can_track_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end

  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name
    "Anonymous"
  end

  def self.search(input)
    input.strip!
    to_send_back = (first_name_matches(input) + last_name_matches(input) + email_matches(input)).uniq
    return nil unless to_send_back
    to_send_back
  end

  def self.first_name_matches(input)
    matches('first_name', input)
  end

  def self.last_name_matches(input)
    matches('last_name', input)
  end

  def self.email_matches(input)
    matches('email', input)
  end

  def self.matches(field_name, input)
    where("#{field_name} like ?", "%#{input}%")
  end

  def except_current_user(users)
    users.reject { |user| user.id == self.id }
  end

  def not_friends_with?(id_of_friend)
    !self.friends.where(id: id_of_friend).exists?
  end

end
