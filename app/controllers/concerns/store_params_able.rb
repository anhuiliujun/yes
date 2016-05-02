module StoreParamsAble
  def build_store(options = {})
    @store ||= Store.new(options)
    @store.attributes = store_params.except(:store_info)
    @store
  end

  def build_store_infos
    StoreInfos.build(store_params[:store_info])
  end

  def store_params
    fields = [:name, :available, :creator_id]
    fields << {admin_attributes: [:id, :first_name, :last_name, :password, :login_name, :mis_login_enabled, :phone_number]}
    fields << {store_info: :value }
    params.require(:store).permit(*fields)
  end

  def set_login_name
    params[:store][:admin_attributes][:login_name] = params[:store][:store_info]["#{InfoCategory.mobile.first.id}"][:value]
  end

  def set_phone_number
    params[:store][:admin_attributes][:phone_number] = params[:store][:store_info]["#{InfoCategory.mobile.first.id}"][:value]
  end

  def set_password
    params[:store][:admin_attributes][:password] = params[:store][:store_info]["#{InfoCategory.mobile.first.id}"][:value][-6,6]
  end

end
