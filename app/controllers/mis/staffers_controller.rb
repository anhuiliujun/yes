class Mis::StaffersController < Mis::BaseController
  skip_before_action :authenticate_admin!, only: [ :update ]
  before_action :set_staffer, only: [:show, :edit, :update, :toggle]
  before_action :set_page_head
  before_action :set_nav, only: [:index, :new, :edit, :show]

  load_and_authorize_resource
  skip_authorize_resource only: [:index]

  def index
    @q = Staffer.search(params[:q])
    @staffers = @q.result.order(id: :desc).paginate(page: params[:page] || 1, per_page: params[:per_page] || 20)
    authorize! :read, @stores
  end

  def show
  end

  def new
    @staffer = Staffer.new
  end

  def edit
  end

  def create
    creator = CreateStafferService.new(Staffer.new(staffer_params))
    if creator.call
      redirect_to mis_staffers_path, notice: 'Staffer was successfully created.'
    else
      redirect_to new_mis_staffer_path, notice: creator.staffer.errors.full_messages.first
    end
  end

  def update
    if @staffer.update(staffer_params)
      redirect_to mis_staffers_path, notice: 'Staffer was successfully updated.'
    else
      redirect_to edit_mis_staffer_path(@staffer), notice: @staffer.errors.full_messages
    end
  end

  def toggle
    @staffer.toggle!
  end

  private

  def set_staffer
    @staffer = Staffer.find(params[:id])
  end

  def staffer_params
    params.require(:staffer).permit(:login_name, :name, :family_name, :password, :password_confirmation, :deleted, :role_id)
  end

  def set_page_head
    @page_head = "设置"
  end

  def set_nav
    @page_nav = PageNavCollection.to_nav(
      [
        {name: '设置', url: 'javascript:void(0)', root: true},
        {name: '运营人员', url: mis_staffers_path},
        {name: Setting.action.send(request[:action]), url: request.path}
      ]
    )
  end
end
