class VehicleManufacturer < ActiveRecord::Base
  has_many :vehicle_series

  validates :name, presence: true, uniqueness: { scope: :vehicle_brand_id}

  def series
    vehicle_series.order('created_at asc')
  end
end
