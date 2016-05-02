class StoreChainSerializer < ActiveModel::Serializer
  attributes :id, :chain_enabled, :stores_count

  def stores_count
    object.stores.size
  end
end
