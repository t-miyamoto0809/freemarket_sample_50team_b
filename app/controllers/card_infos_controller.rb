class CardInfosController < ApplicationController
  require "payjp"

  def new
    card = CardInfo.where(user_id: current_user.id)
    redirect_to action: "show" if card.exists?
  end

  def pay #payjpとCardのデータベース作成を実施します。
    Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
    if params[:payjp_token].blank?
      redirect_to action: "new"
    else
      customer = Payjp::Customer.create(card: params[:payjp_token])
      @card = CardInfo.new(user_id: current_user.id, customer_id: customer.id, card_id: customer.default_card)
      if @card.save
        redirect_to action: "show"
      else
        redirect_to action: "pay"
      end
    end
  end

  def destroy #PayjpとCardデータベースを削除します
    card = CardInfo.where(user_id: current_user.id).first
    Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
    customer = Payjp::Customer.retrieve(card.customer_id)
    customer.delete
    card.delete
    redirect_to action: "show"
  end

  def show #Cardのデータpayjpに送り情報を取り出します
    @card = CardInfo.where(user_id: current_user.id).first
    if @card.blank?
      render "show"
    else
      Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
      customer = Payjp::Customer.retrieve(@card.customer_id)
      @default_card_information = customer.cards.retrieve(@card.card_id)
      @card_brand = @default_card_information.brand #カード会社のブランドアイコンを表示
      case @card_brand
      when "Visa"
        @card_src = "visa.svg"
      when "JCB"
        @card_src = "jcb.svg"
      when "MasterCard"
        @card_src = "master-card.svg"
      when "American Express"
        @card_src = "american_express.svg"
      when "Diners Club"
        @card_src = "dinersclub.svg"
      when "Discover"
        @card_src = "discover.svg"
      end
    end
  end
end
