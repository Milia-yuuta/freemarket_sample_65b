class PurchaseController < ApplicationController
  before_action :redirect_to_sign_in, only: [:pay, :buy]
  before_action :set_item, only: [:pay, :buy, :done, :redirect_to_item_show_if_own_item, :redirect_to_item_show_if_item_sold, :transaction_comp]
  before_action :redirect_to_item_show_if_own_item, only: [:pay, :buy]
  before_action :redirect_to_item_show_if_item_sold, only: [:pay, :buy]
  before_action :redirect_to_credit_new, only: [:pay, :buy]
  before_action :get_payjp_info, only: [:pay, :buy]

  require 'payjp'

  def buy
    @image = Image.find(params[:item_id])
    @address = Address.find_by(user_id: current_user.id)
    @user = User.find_by(id: current_user.id)

    customer = Payjp::Customer.retrieve(@creditcard.customer_id)
      @default_card_information = customer.cards.retrieve(@creditcard.card_id)
  end

  def pay
    @creditcard = Creditcard.find_by(user_id: current_user.id)
    if @item.blank?
      redirect_to action: "buy"
    else
    Payjp::Charge.create(
      amount: @item.price,
      customer: @creditcard.customer_id,
      currency: 'jpy'
     )

      @item.update(level: 1, buyer_id: current_user.id)
      redirect_to done_item_purchase_index_path
    end
  end

  def done
  end

  def transaction_comp
    @item.update(level: 2)
    redirect_to item_path(@item.id)
  end

  private
  def redirect_to_credit_new
    @creditcard = Creditcard.find_by(user_id: current_user.id)
    if @creditcard.blank?
      redirect_to controller: "creditcards", action: "new"
    end
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

  def get_payjp_info
      Payjp.api_key = Rails.application.credentials.dig(:payjp, :PAYJP_SECRET_KEY)
  end

  def redirect_to_sign_in
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end

  def redirect_to_item_show_if_own_item
    if @item.seller_id == current_user.id
      redirect_to item_path(params[:item_id])
    end
  end

  def redirect_to_item_show_if_item_sold
    if @item.level != 0
      redirect_to item_path(params[:item_id])
    end
  end

end
