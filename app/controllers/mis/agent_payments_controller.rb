class Mis::AgentPaymentsController < Mis::BaseController
  before_action :set_page_head
  before_action :set_nav, only: [:index, :new, :edit, :show]
  before_action :payment_params, only:[:create]

  def create
    @agent_payments = AgentPayment.new(payment_params.merge(agent_id: Staffer.find(params[:staffer_id]).agent.id))
    if @agent_payments.save
      @agent = Agent.find(@agent_payments.agent_id)
    else
      redirect_to edit_mis_agent_path(params[:id]), notice: '续费失败！'
    end
  end

  def show
    @staffer = Staffer.find(params[:staffer_id])
    @agent_payments = @staffer.agent.agent_payments
  end

  private
  def payment_params
    fields = [:amount, :quantity, :price, :creator_id]
    params.permit(fields)
  end

  def set_page_head
    @page_head = '设置'
  end

  def set_nav
    @page_nav = PageNavCollection.to_nav(
      [
        {name: '设置', url: 'javascript:void(0)', root: true},
        {name: '经销商', url: 'javascript:void(0)'},
        {name: '消费记录', url: request.path}
      ]
    )
  end
end
