class StoreSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at

  has_one :my_chain

  has_one :admin
end
