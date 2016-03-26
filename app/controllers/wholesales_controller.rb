class WholesalesController < ApplicationController
  
  def new
    merchant = Merchant.find(session[:merchant_id])
    if merchant.current_order.nil?
      merchant.current_order = merchant.orders.create!
      merchant.save!
    end
    redirect_to edit_wholesale_path
  end
  
  
  def edit
    @merchant = Merchant.find(session[:merchant_id])
    @kingdoms = Kingdom.order(:name)
  end
  
  
  def edit_product
    @merchant = Merchant.find(session[:merchant_id])
    @order = @merchant.current_order
    @product = Product.find(params[:id])
  end
  
  
  def update_order
    merchant = Merchant.find session[:merchant_id]
    order = merchant.current_order
    build = Build.find params[:build_id]
    result = order.update_item_from_build build, params[:quantity], true
    render json: result
  end
  
  
  def checkout
    @items_count = merchant.current_order.items.count
  end
  
end
