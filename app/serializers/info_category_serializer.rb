class InfoCategorySerializer < ActiveModel::Serializer

	attributes :id, :name, :code

	def initialize(object, store)
		super(object)
		@store = store
	end

	def current_info_value_by_store
	  current_info.value
	end

	def current_info
		object.store_infos.of_store(@store).normal.first || NullObject.new
	end

	def render(view = nil)
		template = "mis/store_infos/#{self.code.to_s+"_info"}"
		view.render template, category: self
	end

	def render_for_show(view = nil)
		template = "mis/store_infos/#{self.code.to_s+"_info_show"}"
		view.render template, category: self
	end
end
