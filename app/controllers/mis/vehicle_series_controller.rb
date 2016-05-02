class Mis::VehicleSeriesController < Mis::BaseController
  respond_to :json

  before_action :set_manufacturer, only: [:create]
  before_action :set_series, except: [:create]

  def index
    @models = @series.vehicle_models.order('created_at asc')
    respond_with @models, location: nil
  end

  def create
    @series = @manufacturer.vehicle_series.create(series_params.merge(brand_param))
  end

  def show
    respond_with @series, location: nil
  end

  def update
    if @series.update(series_params)
      render json: { status: true }
    else
      render json: { status: false, notice: @series.errors.full_messages.to_sentence }
    end
  end

  private

    def set_series
      @series = VehicleSeries.find(params[:id])
    end

    def set_manufacturer
      @manufacturer = VehicleManufacturer.find(params[:manufacturer_id])
    end

    def series_params
      params.require(:vehicle_series).permit(:name, :min, :max)
    end

    def brand_param
      { vehicle_brand_id: @manufacturer.vehicle_brand_id }
    end
end
