class StorePayment < ActiveRecord::Base
  include BaseModel

  FEE_PER_MONTH = 500

  validates :paid_at, presence: true

  validates :amount, presence: true, numericality: { greater_than: 0 }

  scope :by_renewal_type, ->(renewal_type) { where(renewal_type_id: renewal_type) }

  PAYMENT_TYPE = {
    '银行卡' => 0,
    '现金' => 1,
    '支付宝' => 2
  }

  INVOICE_TYPE = {
    '无' => 0,
    '普票' => 1,
    '专票' => 2
  }

  RECEIPT_REQUIRED = {
    '有' => true,
    '无' => false
  }

  RENEWAL_TYPE = {
    '软件续费' => 0,
    '短信续费' => 1
  }

  def software?
    self.renewal_type_id == RENEWAL_TYPE['软件续费']
  end

  def payment_type_name
    PAYMENT_TYPE.invert[self.payment_type_id]
  end

  def invoice_type_name
    INVOICE_TYPE.invert[self.invoice_type_id]
  end

  def receipt_required_name
    RECEIPT_REQUIRED.invert[self.receipt_required]
  end

  def paid_months
    (self.amount/FEE_PER_MONTH).to_i if self.software?
  end

  def payer
    self.remark.present? ? self.remark : self.store.name
  end

end
