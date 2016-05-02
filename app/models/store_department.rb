class StoreDepartment < ActiveRecord::Base
  belongs_to :store
  belongs_to :store_chain
  belongs_to :creator, class_name: 'StoreStaff', foreign_key: :store_staff_id

  validates :store_chain_id, presence: true
  validates :store_id, presence: true
  validates :store_staff_id, presence: true


  has_many :store_positions
  belongs_to :parent, class_name: 'StoreDepartment'
  has_many :children, class_name: 'StoreDepartment', foreign_key: :parent_id

  validates_presence_of :name
  validates :parent, presence: true, unless: ->(m){m.parent_id == 0}

  scope :root_departments, ->(){where(parent_id: 0)}

end
