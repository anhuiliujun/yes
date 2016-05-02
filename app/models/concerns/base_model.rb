module BaseModel
	def self.included(base)
		base.class_eval do
			belongs_to :store
			belongs_to :store_chain

			validates :store_id, presence: true
			validates :store_chain_id, presence: true

			before_validation :set_store_attrs
	  end
	end

	def set_store_attrs
		self.store_chain_id = self.store.store_chain_id if self.store
	end
end
