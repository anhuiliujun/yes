module Mis
  module StoresHelper
    def set_admin_url(store)
      link_to '设为总店', [:set_admin, :mis, store.store_chain, store], remote: true, method: :put ,data: { confirm: '你确定要将本门店置为总店吗?' }
    end
  end
end
