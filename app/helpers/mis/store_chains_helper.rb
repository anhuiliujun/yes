module Mis
  module StoreChainsHelper
    def store_chain_target(store)
      store.persisted? ? mis_store_chain_path(store.store_chain) : mis_store_chains_path
    end

    def store_chain_method(sc)
      sc.persisted? ? :put : :post
    end

    def toggle_available_url(store)
      name, css = store.available ? ['暂停使用', 'stop'] : ['恢复使用', 'recover']
      raw link_to name, 'javascript:void(0)', class: "#{css} color-0096D3", "data-id": store.id
    end

    def branch?(store)
      if store.branch?
        raw link_to '有分店', "/mis/stores?id=#{store.id}", class: 'color-0096D3'
      else
        raw label_tag nil, '无分店', class: 'color-0096D3 no_branch'
      end
    end
  end
end
