class Api::RolesController < Api::BaseController
  before_action :set_role, only: [:show, :update, :destroy]

  def show
    respond_with @role
  end

  def index
    @q = Role.search(params[:q])
    @roles = @q.result.order(id: :desc).paginate(page: params[:page] || 1, per_page: params[:per_page] || 20)
    respond_with @roles
  end

  def create
    @role = Role.create(role_params)
    respond_with @role
  end

  def update
    @role.update role_params
    respond_with @role
  end

  def destroy
    @role.destroy
    respond_with @role
  end

  private
  
  def set_role
    @role = Role.find(params[:id])
  end

  def role_params
    params.permit(:name, :abbrev, :description, :position)
  end
end
