class Mis::StoresController < Mis::BaseController
  before_action :set_login_name, :set_phone_number, :set_password, only:[:create]
  before_action :set_store, :set_categories, only:[:index, :show, :edit, :update]
  before_action :set_page_head
  before_action :set_nav, only: [:index, :new, :edit, :show]
  before_action :set_search_url, only: [:index]

  def index
    @q = Store.branches_at_head_office(@store.store_chain_id, @store.id).ransack(params[:q])
    @stores = @q.result(distinct: true).order(id: :asc).paginate(page: params[:page] || 1, per_page: 10)
    @stores = @stores.where(creator_id: current_staffer.id) if current_staffer.role_id != 1
  end

  def new
    @store_chain = StoreChain.find(params[:store_chain_id])
    @store = Store.new(admin: StoreStaff.new)
    @categories = InfoCategory.sub_basic.map { |c| InfoCategorySerializer.new(c, @store) }
  end

  def create
    @store_chain = StoreChain.find(params[:store_chain_id])
    store_creation = CreateStoreService.new(build_store, build_store_infos, @store_chain)
    if store_creation.call
      redirect_to mis_store_path(store_creation.store), notice: 'Store was successfully created.'
    else
      redirect_to new_mis_store_path(store_chain_id: @store_chain), notice: '手机号为11位数字!'
    end
  end

  def show
    authorize! :manage, @store
  end

  def update
    if CreateOperationLogService.call StafferOperationLog.new(log_params)
      flash[:notice] = "#{@store.name}#{@store.available ? '恢复成功!' : '停用成功!'}"
      render json: {status: true}
    else
      flash[:alert] = '操作失败!'
      render json: {status: false}
    end
  end

  private
    include StoreParamsAble

    def log_params
      {
        resource: @store,
        staffer_id: current_staffer.id,
        log: {
          reason: params[:reason],
          from: @store.available,
          to: !@store.available,
          operation: 'update',
          field: 'available' }
      }
    end

    def set_store
      @store = Store.find(params[:id])
    end

    def set_categories
      @categories = InfoCategory.sub_basic.map { |c| InfoCategorySerializer.new(c, @store) }
    end

    def set_page_head
      @page_head = "门店信息"
    end

    def set_search_url
      @search_url = mis_stores_path
    end

    def set_nav
      store_id, param_name = params[:store_chain_id] ? [StoreChain.admin_store_id(params[:store_chain_id]), 'store_chain_id'] : [params[:id], 'id']
      url = request[:action] == 'show' ? request.path : "#{request.path}?#{param_name}=#{store_id}"
      @page_nav = PageNavCollection.to_nav(
        [
          {name: '门店信息', url: 'javascript:void(0)', root: true},
          {name: '分店', url: mis_stores_path(id: store_id)},
          {name: Setting.action.send(request[:action]), url: url}
        ]
      )
    end
end
