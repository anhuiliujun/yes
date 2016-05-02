class Mis::VehiclesController < Mis::BaseController
  def index
    @brands = VehicleBrand.all.order("created_at asc").group_by{ |b| b.letter }.sort
  end
end
