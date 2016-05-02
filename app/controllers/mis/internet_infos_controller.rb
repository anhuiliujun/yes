class Mis::InternetInfosController < Mis::BaseController
	include StoreInfoAble
	before_action :set_nav, only: [:index, :new, :edit, :show]

	def set_nav
		name, url = @store.my_chain ? ['门店', mis_store_chains_path] : ['分店', mis_stores_path(id: @store.id)]
		@page_nav = PageNavCollection.to_nav(
			[
				{name: name, url: url, root: true},
				{name: '网络信息', url: 'javascript:void(0)'},
				{name: Setting.action.send(request[:action]), url: request.path}
			]
		)
	end
end
