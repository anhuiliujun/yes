class Api::BaseController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_admin!

  respond_to :json

  private

  def default_serializer_options
    {root: false}
  end

  def load_locale
    I18n.locale = "zh-CN"
  end

  def authenticate_admin!
    redirect_to new_staffer_session_path and return if current_staffer.blank?
    sign_out(current_staffer) and redirect_to new_staffer_session_path and return if current_staffer.deleted?
    render_403 and return if !current_staffer.admin and current_staffer.role_id.blank?
  end

  # cancan
  def current_ability
    @current_ability ||= Ability.new(current_staffer)
  end

  rescue_from CanCan::AccessDenied do |exception|
    render :template => 'shared/forbidden', :status => 403
  end

  def render_403
    render :template => 'shared/forbidden', :status => 403
  end
end
