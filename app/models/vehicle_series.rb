class VehicleSeries < ActiveRecord::Base
  has_many :vehicle_models
  belongs_to :vehicle_brand
  belongs_to :vehicle_manufacturer

  validates :name, presence: true, uniqueness: {scope: :vehicle_manufacturer_id}

  def suggested_price
    (min.present? || max.present?) ? "#{min}-#{max}万" : "暂无"
  end

end
