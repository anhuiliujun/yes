class VehicleModel < ActiveRecord::Base
  belongs_to :vehicle_series

  validates :name, presence: true, uniqueness: {scope: :vehicle_series_id}
end
