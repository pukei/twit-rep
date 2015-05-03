class Payment < ActiveRecord::Base
  attr_accessible :account_id, :amount, :digital, :recurring, :popup, :identifier, :plan_id

  validates :token, uniqueness: true
  validates :amount, presence: true
  validates :identifier, uniqueness: true
  scope :recurring, where(recurring: true)
  scope :digital,   where(digital: true)
  scope :popup,     where(popup: true)

  belongs_to :account

  def goods_type
    digital? ? :digital : :real
  end

  def payment_type
    recurring? ? :recurring : :instant
  end

  def ux_type
    popup? ? :popup : :redirect
  end

  def details
    if recurring?
      client.subscription(self.identifier)
    else
      client.details(self.token)
    end
  end

  attr_reader :redirect_uri, :popup_uri
  def setup!(return_url, cancel_url)
    response = client.setup(
      payment_request,
      return_url,
      cancel_url,
      pay_on_paypal: true,
      no_shipping: self.digital?
    )
    self.token = response.token
    self.save!
    @redirect_uri = response.redirect_uri
    @popup_uri = response.popup_uri
    Rails.logger.info "@@@ 11 #{response.inspect}"
    Rails.logger.info "@@@ 22 #{response.token}"
    self
  end

  def cancel!
    self.canceled = true
    self.save!
    self
  end

  def complete!(current_user, payer_id = nil)
    if self.recurring?
      response = client.subscribe!(self.token, recurring_request)
      self.identifier = response.recurring.identifier
    else
      response = client.checkout!(self.token, payer_id, payment_request)
      self.payer_id = payer_id
      self.identifier = response.payment_info.first.transaction_id
    end


    current_user.account.payment.unsubscribe!(current_user, false) if current_user.account.payment

    a_new = Account.create_new_account(current_user, self.plan_id)

    self.account_id = a_new.id

    self.completed = true
    self.save!

    Rails.logger.info "@@@ 34 #{response.inspect}"
    self
  end

  def unsubscribe!(current_user, from_destroy=true)
    client.renew!(self.identifier, :Cancel)

    a_new = Account.create_new_account(current_user) if from_destroy

    self.cancel!
  end

  private

  def client
    Paypal::Express::Request.new PAYPAL_CONFIG
  end

  DESCRIPTION = {
    item: 'PayPal Express Sample Item',
    instant: 'PayPal Express Sample Instant Payment',
    recurring: 'PayPal Express Sample Recurring Payment'
  }

  def payment_request
    request_attributes = if self.recurring?
      {
        billing_type: :RecurringPayments,
        billing_agreement_description: DESCRIPTION[:recurring]
      }
    else
      item = {
        name: DESCRIPTION[:item],
        description: DESCRIPTION[:item],
        amount: self.amount
      }
      item[:category] = :Digital if self.digital?
      {
        amount: self.amount,
        description: DESCRIPTION[:instant],
        items: [item]
      }
    end
    Paypal::Payment::Request.new request_attributes
  end

  def recurring_request
    Paypal::Payment::Recurring.new(
      start_date: Time.now,
      description: DESCRIPTION[:recurring],
      billing: {
        period: :Month,
        frequency: 1,
        amount: self.amount
      }
    )
  end

end
