class PaymentsController < ApplicationController
  rescue_from Paypal::Exception::APIError, with: :paypal_api_error

  def show
    @payment = Payment.find_by_identifier! params[:id]
  end

  def create
    payment = Payment.create! params[:payment]
    payment.setup!(
      success_payments_url,
      cancel_payments_url
    )
    if payment.popup?
      # redirect_to payment.popup_uri
      redirect_to payment.redirect_uri
    else
      redirect_to payment.redirect_uri
    end
  end

  def destroy
    # Payment.find_by_identifier!(params[:id]).unsubscribe!
    current_user.account.payment.unsubscribe!(current_user)

    # redirect_to root_path, notice: 'Recurring Profile Canceled'
    redirect_to account_users_url(:tab => "plan")
  end

  def success
    handle_callback do |payment|
      payment.complete!(current_user, params[:PayerID])
      flash[:notice] = 'Payment Transaction Completed'
      # payment_url(payment.identifier)
      account_users_url(:tab => "plan")
    end
  end

  def cancel
    handle_callback do |payment|
      payment.cancel!
      flash[:warn] = 'Payment Request Canceled'
      root_url
    end
  end

  private

  def handle_callback
    payment = Payment.find_by_token! params[:token]
    @redirect_uri = yield payment
    if payment.popup?
      # render :close_flow, layout: false
      redirect_to @redirect_uri
    else
      redirect_to @redirect_uri
    end
  end

  def paypal_api_error(e)
    redirect_to root_url, error: e.response.details.collect(&:long_message).join('<br />')
  end

end
