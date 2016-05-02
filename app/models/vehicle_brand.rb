class VehicleBrand < ActiveRecord::Base
  has_many :vehicle_manufacturers
  has_many :vehicle_series

  validates :name, presence: true, uniqueness: true

  def manufacturers
    vehicle_manufacturers.order('created_at asc')
  end
end
