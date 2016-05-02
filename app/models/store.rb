class Store <  ActiveRecord::Base
  attr_writer :head_office

  # 所属连锁店
  belongs_to :store_chain
  # 门店管理员
  belongs_to :admin, class_name: 'StoreStaff', autosave: true, dependent: :destroy
  # 所有店员
  has_many :store_staffs
  # 可能是连锁店的总店
  has_one :my_chain, class_name: 'StoreChain', foreign_key: 'admin_store_id'

  has_many :store_infos

  has_many :staffer_operation_logs, as: :resource

  has_many :store_payments

  has_many :ca_stations

  has_many :store_departments

  has_many :store_settlement_accounts

  has_many :store_depots

  accepts_nested_attributes_for :admin

  validates :name, presence: true

  NOTICE_DAYS = 15

  STORE_TYPE = {
    '门店类型' => 'all_office',
    '总店' => 'head_office',
    '分店' => 'branch_office'
  }

  AVAILABLE = {
    '可用' => true,
    '不可用' => false
  }

  PAYMENT_STATUS = {
    '待缴费' => 0,
    '已缴费' => 1,
    '欠费' => 2
  }

  scope :head_office, -> { joins(:store_chain).where("stores.id = store_chains.admin_store_id") }

  scope :branch_office, -> { joins(:store_chain).where("stores.id != store_chains.admin_store_id") }

  scope :all_office, -> { joins(:store_chain) }

  scope :branches_at_head_office, ->(store_chain_id, head_office_id) { joins(:store_chain).where(store_chain_id: store_chain_id).where.not(id: head_office_id) }

  def province_value
    info_category = InfoCategory.find_by(:name => '省份')
    province_value = (self.store_infos.by_category(info_category.id).normal.first || NullObject.new).value
    (Geo.provinces("1").where(code: province_value).first || NullObject.new).name
  end

  def branch_number
    self.store_chain.stores.count-1
  end

  def infos_by_category(info_id)
    store_infos.by_category(info_id).last || NullObject.new
  end

  def prolong_service!(months)
    self.expired_at ||= Time.now
    self.update!(expired_at: self.expired_at.months_since(months))
  end

  def change_payment_status!
    self.update!(payment_status: PAYMENT_STATUS['已缴费']) if self.expired_at > Time.now
  end

  def available_name
    AVAILABLE.invert[self.available]
  end

  def payment_status_name
    PAYMENT_STATUS.invert[self.payment_status]
  end

  def branch?
    self.my_chain && self.branch_number > 0
  end

  def toggle_available!
    self.update!(available: !self.available)
  end

  def update_balance!(amount)
    self.balance ||= 0       # 短信余额字段默认值设为0，否则需要初始化
    self.update!(balance: self.balance + amount)
  end

  def expire_notice_required?
    return false if self.expired_at.blank?
    self.expired_at < NOTICE_DAYS.days.from_now
  end

  def owing?
    self.payment_status == PAYMENT_STATUS['欠费']
  end

  def balance_empty?
    self.balance == 0
  end

  def head_office?
    @head_office
  end
end
