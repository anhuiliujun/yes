class StorePosition < ActiveRecord::Base
  belongs_to :store
  belongs_to :store_chain
  belongs_to :creator, class_name: 'StoreStaff', foreign_key: :store_staff_id

  validates :store_chain_id, presence: true
  validates :store_id, presence: true
  validates :store_staff_id, presence: true



  belongs_to :store_department
  has_many :store_staff

  validates_presence_of :name
  validates_presence_of :store_department_id
  validates :store_department, presence: true
end
