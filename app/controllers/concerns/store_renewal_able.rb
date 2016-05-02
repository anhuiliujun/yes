module StoreRenewalAble
  def self.included(base)
    base.module_eval do
      before_action :set_store, only: [:create, :new]
      before_action :set_page_head
      before_action :set_search_url, only: [:index]
      helper_method :url, :target_name

      define_method :resource do
        base.to_s.demodulize.underscore.split("_").first
      end

      define_method :redirect_url do |action, options = {}|
        path = action == :new ? "new_mis_#{resource.singularize}_path" : "mis_#{resource}_path"
        self.send(path, options)
      end
    end
  end

  def index
    @q = Store.ransack(params[:q])
    @stores = @q.result(distinct: true).order("#{order_by} ASC").paginate(page: params[:page] || 1, per_page: 10)
    authorize! :read, @stores
  end

  def create
    payment = StorePayment.new(append_store_attrs payments_params.merge(renewal_type_id: renewal_type))
    if CreateStorePaymentService.call payment
      redirect_to redirect_url(:index), notice: "#{@store.name}续费#{payment.amount}元成功!"
    else
      redirect_to redirect_url(:new, store_id: @store.id), alert: payment.errors.full_messages.to_sentence
    end
  end

  def new
    @payment = StorePayment.new
    authorize! :read, @payment
  end

  def show
    @store = Store.find(params[:id])
    @store_payments = @store.store_payments.by_renewal_type(renewal_type).order(paid_at: :desc).paginate(page: params[:page] || 1, per_page: 10)
  end

  private

    def payments_params
      params.require(:store_payment).permit(:paid_at, :amount, :payment_type_id, :invoice_type_id, :receipt_required, :remark)
    end

    def set_store
      @store = Store.find(params[:store_id])
    end

    def set_page_head
      @page_head = "续费管理"
    end

    def set_search_url
      @search_url = url
    end

end
