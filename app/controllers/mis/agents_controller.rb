class Mis::AgentsController < Mis::BaseController
  before_action :set_page_head
  before_action :set_nav, only: [:index, :new, :edit, :show]
  before_action :set_staffer, only:[:show, :edit, :update]

  def index
    @q = Staffer.where(role_id: '2').search(params[:q])
    @staffers = @q.result.order(id: :desc).paginate(page: params[:page] || 1, per_page: params[:per_page] || 20)
  end

  def new
    @staffer = Staffer.new(agent: Agent.new)
  end

  def create
    creator = CreateStafferService.new(Staffer.new(staffer_params))
    if creator.call
      redirect_to mis_staffers_path, notice: '经营商创建成功！'
    else
      redirect_to new_mis_agent_path, notice: creator.staffer.errors.full_messages.first
    end
  end

  def show

  end

  def edit

  end

  def update
    if @staffer.update(staffer_params)
      redirect_to mis_agent_path(params[:id]), notice: '更新成功！'
    else
      redirect_to edit_mis_agent_path(params[:id]), notice: @staffer.errors.messages.first
    end
  end

  private
  def set_page_head
    @page_head = '设置'
  end

  def staffer_params
    params.require(:staffer).permit(:login_name, :family_name, :name, :password, :password_confirmation, :deleted, :role_id,
    agent_attributes:[:id, :company_name, :company_address, :phone_number, :charge_area, :cooperation_way, :remark, :quota, :balance, :creator_id ])
  end

  def set_staffer
    @staffer = Staffer.find(params[:id])
  end

  def set_nav
    @page_nav = PageNavCollection.to_nav(
      [
        {name: '设置', url: 'javascript:void(0)', root: true},
        {name: '经销商', url: 'javascript:void(0)'},
        {name: Setting.action.send(request[:action]), url: request.path}
      ]
    )
  end
end
