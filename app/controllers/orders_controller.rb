class OrdersController < ApplicationController
  
  def create
    builds_data = JSON.parse order_params[:builds] # From JS
    notes = order_params[:notes] # From Angular
    quantity = order_params[:quantity].to_i # From JS
    shippingAddress = JSON.parse order_params[:shippingAddress] # From Angular
    token = order_params[:token] # From JS
    
    builds = builds_data.map { |id, q| Build.find(id) }
    
    amount = builds.map(&:price_retail).reduce(0, :+) # In cents
    description = "#{quantity} Item #{quantity == 1 ? "" : "s"} from Fehu Inc."
    
    # customer = Stripe::Customer.create(
    #   email: shippingAddress["email"],
    #   source: token
    # )
    
    charge = Stripe::Charge.create(
      # customer: customer.id,
      source: token,
      amount: amount,
      description: description,
      currency: "CAD"
    )
    
    order = Order.new(
      notes: notes
    )
    
    builds.each do |build|
      order.items.new(
        build: build,
        build_name: build.build_name,
        product_name: build.product_name,
        price: build.price_retail,
        quantity: builds_data[build.id].quantity
      )
    end
    
    redirect_to order_path(order)
    
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to payment_path
  end
  
private
  
  def order_params
    params.permit(:token, :builds, :shippingAddress, :notes)
  end

end
