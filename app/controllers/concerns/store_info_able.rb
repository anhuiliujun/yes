module StoreInfoAble
  def self.included(base)
    base.module_eval do
      before_action :set_store, :set_page_head, :set_info_category, only:[:create,:show, :edit, :new]

    if base.to_s.demodulize.underscore.split("_").first == "ficilities"
      	before_action :set_station, only: [:show, :edit, :create, :new]
    end

      define_method :resource do
	       base.to_s.demodulize.underscore.split("_").first
      end

      define_method :set_info_category do
        @categories = InfoCategory.send("sub_#{resource}").map { |c| InfoCategorySerializer.new(c, @store) }
      end

      define_method :redirect_url do |store|
	       self.send("mis_store_#{resource}_infos_path", store)
      end
    end
  end

	def new
		@store_info = StoreInfo.new
	end

	def create
    @categories.each do |category|
      category.current_info.to_history!
      @store.store_infos.create(value: params[:store_info]["#{category.id}"][:value], info_category_id: category.id)
		end
		redirect_to redirect_url(@store)
	end

	def show
	end

	def edit
		@store_info = @store
	end

	private
	def set_store
		@store = Store.find(params[:store_id])
	end

	def set_station
		@stations = CaStation.where(store_id: @store.id)
	end

  def set_page_head
    @page_head = "门店信息"
  end
end
