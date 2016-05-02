class Api::StoreChainsController < Api::BaseController
  before_action :set_store_chain, only: [:show]
  before_action :set_store, only: [:update]

  def show
    respond_with @store_chain.admin_store
  end

  def index
    @q = Store.head_office.search(params[:q])
    @stores = @q.result.order(id: :desc).paginate(page: params[:page] || 1, per_page: params[:per_page] || 20)
    respond_with @stores
  end

  def update
    @store.update(update_store_params)
    respond_with @store
  end

  def create
    store_creation = CreateStoreService.new(Store.new, store_params)
    store_creation.call
    respond_with store_creation.store
  end

  private
  
  def set_store_chain
    @store_chain = StoreChain.find(params[:id])
  end

  def set_store
    @store = Store.find(params[:id])
  end

  def store_params
    params.permit(:name, admin_attributes:[:id, :first_name, :last_name, :name_display_type, :gender, :login_name, :password, :password_confirmation])
  end

  def update_store_params
    params.permit(:name)
  end

end
