class Mis::StoreChainsController < Mis::BaseController
    before_action :set_login_name, :set_phone_number, only:[:create, :update]
    before_action :set_page_head
    before_action :set_nav, only: [:index, :new, :edit, :show]
    before_action :set_store, only:[:show, :edit, :update]
    before_action :set_categories, only:[:show, :edit, :update]
    before_action :set_search_url, only: [:index]

    def index
      unless params[:q]
        params.merge!(q: {store_type: "head_office"})
        @q = Store.includes(:store_chain).send(params[:q][:store_type].to_sym).ransack
      else
        @q = params[:q].length > 1 ? Store.includes(:store_chain).send(params[:q][:store_type].to_sym).ransack(params[:q]) : Store.ransack(params[:q])
      end
      @stores = @q.result(distinct: true).order(id: :asc).paginate(page: params[:page] || 1, per_page: 10)
      @search = {
                  store_type: params[:q][:store_type],
                  available: params[:q][:available_eq],
                  payment_status: params[:q][:payment_status_eq],
                  province: params[:q][:store_infos_value_eq],
                  store_name: params[:q][:name_cont]
                }
      @stores = @q.result(distinct: true).where(creator_id: current_staffer.id).order(id: :asc).paginate(page: params[:page] || 1, per_page: 10) if current_staffer.role_id != 1
    end

    def show
      authorize! :manage, @store
    end

    def new
      @info_category = InfoCategory.category
      @store= Store.new(admin: StoreStaff.new)
      @categories = InfoCategory.sub_basic.map { |c| InfoCategorySerializer.new(c, @store) }
    end

    def edit
      authorize! :manage, @store
    end

    def create
      set_password
      creator = CreateStoreService.new(build_store(head_office: true), build_store_infos)
      if creator.call
        redirect_to mis_store_chain_path(creator.store_chain.admin_store)
      else
        redirect_to new_mis_store_chain_path, notice: '手机号为11位数字!'
      end
    end

    def update
      updater = UpdateStoreService.new(build_store, build_store_infos)
      if updater.call
        redirect_to mis_store_chain_path(params[:id])
      else
        redirect_to edit_mis_store_chain_path(@store), notice: "更新失败,手机号为11位数字!"
      end
    end

    def city_code
      set_code
    end

    def regions_code
      set_code
      @provinces = params[:provinces]
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

      def set_code
        @code = params[:code]
        @category = params[:category_id]
      end

      def set_page_head
        @page_head = "门店信息"
      end

      def set_search_url
        @search_url = mis_store_chains_path
      end

      def set_nav
        @page_nav = PageNavCollection.to_nav(
          [
            {name: '门店信息', url: 'javascript:void(0)', root: true},
            {name: '门店', url: mis_store_chains_path},
            {name: Setting.action.send(request[:action]), url: request.path}
          ]
        )
      end
end
