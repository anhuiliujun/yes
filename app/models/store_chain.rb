class StoreChain <  ActiveRecord::Base
  # 所有门店
  has_many :stores
  # 所有店员(冗余关系: 可以通过stores获得)
  has_many :store_staff
  # 总店管理员(冗余字段: 可以通过admin_store获得)
  belongs_to :chain_admin, class_name: 'StoreStaff', foreign_key: 'admin_id'
  # 连锁店的总店
  belongs_to :admin_store, class_name: 'Store'

  scope :admin_store_id, ->(id){ StoreChain.find(id).admin_store_id }

  has_many :store_departments
end
