class SessionsController < Devise::SessionsController
  skip_before_action :authenticate_admin!, only: [ :new, :create, :destroy ]
  layout false

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource) unless resource.deleted?
    respond_with resource, :location => after_sign_in_path_for(resource)
  end

  protected
  def after_sign_in_path_for(resource)
    root_path
  end
end
