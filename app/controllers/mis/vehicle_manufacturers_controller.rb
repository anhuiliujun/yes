class Mis::VehicleManufacturersController < Mis::BaseController

  before_action :set_brand, only: [:create]
  before_action :set_manufacturer, only: [:update]

  def create
    @manufacturer = @brand.vehicle_manufacturers.create(manufacturer_params)
  end

  def update
    if @manufacturer.update(name: params[:name])
      render json: { status: true }
    else
      render json: { status: false, notice: @manufacturer.errors.full_messages.to_sentence }
    end
  end

  private

    def set_brand
      @brand = VehicleBrand.find(params[:brand_id])
    end

    def set_manufacturer
      @manufacturer = VehicleManufacturer.find(params[:id])
    end

    def manufacturer_params
      params.require(:vehicle_manufacturer).permit(:name)
    end
end
