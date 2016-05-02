class Mis::StoreStaffsController < Mis::BaseController
  before_action :set_page_head, :set_nav, except: [:update]
  before_action :set_store, only: [:index]
  def index
    @store_staffs = @store.store_staffs.order(id: :desc).paginate(page: params[:page] || 1, per_page: params[:per_page] || 20)
  end

  def update
    @store_staff = StoreStaff.find(params[:id])
    @store_staff.reset_password!(params[:password], params[:confirmation])
  end

  private
  def set_store
    @store = Store.find(params[:store_id])
  end

  def set_page_head
    @page_head = "员工列表"
  end

  def set_nav
    @page_nav = PageNavCollection.to_nav(
      [
        {name: '门店信s息', url: 'javascript:void(0)', root: true},
        {name: '门店管理', url: mis_staffers_path},
        {name: Setting.action.send(request[:action]), url: request.path}
      ]
    )
  end
end
