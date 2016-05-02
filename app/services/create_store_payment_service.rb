class CreateStorePaymentService
  include Serviceable

  def initialize(payment)
    @store_payment = payment
  end

  def call
    @store_payment.transaction do
      @store_payment.save!
      if @store_payment.software?
        @store_payment.store.prolong_service!(@store_payment.amount/StorePayment::FEE_PER_MONTH)
        @store_payment.store.change_payment_status!
      else
        @store_payment.store.update_balance!(@store_payment.amount)
      end
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end
end
