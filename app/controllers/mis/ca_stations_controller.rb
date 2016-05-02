class Mis::CaStationsController < Mis::BaseController
	before_action :set_store, :set_station, only: [:create, :destroy]
	def create
		@ca_station=@store.ca_stations.create(name: params[:name],quantity: params[:quanlity],store_chain_id: @store.store_chain_id)
	end

	def destroy
		@id = params[:id]
		@store.ca_stations.find(params[:id]).destroy
	end
	
	private
	def set_store
		@store = Store.find(params[:store_id])
	end

	def set_station
		@stations = @store.ca_stations
	end
end