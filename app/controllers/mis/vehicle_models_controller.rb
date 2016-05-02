class Mis::VehicleModelsController < Mis::BaseController

  before_action :set_series, only: [:create]
  before_action :set_model, only: [:update]

  def create
    @model = @series.vehicle_models.create(model_params)
  end

  def update
    if @model.update(model_params)
      render json: { status: true }
    else
      render json: { status: false, notice: @model.errors.full_messages.to_sentence }
    end
  end

  private

    def set_series
      @series = VehicleSeries.find(params[:series_id])
    end

    def set_model
      @model = VehicleModel.find(params[:id])
    end

    def model_params
      params.require(:vehicle_model).permit(:name)
    end

end
