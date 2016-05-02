class Mis::VehicleBrandsController < Mis::BaseController

  before_action :set_brand, only: [:update]

  def create
    @brand = VehicleBrand.create(brand_params)
  end

  def update
    if @brand.update(name: params[:name])
      render json: { status: true }
    else
      render json: { status: false, notice: @brand.errors.full_messages.to_sentence }
    end
  end

  private

    def brand_params
      params.require(:vehicle_brand).permit(:name, :letter)
    end

    def set_brand
      @brand = VehicleBrand.find(params[:id])
    end
end
