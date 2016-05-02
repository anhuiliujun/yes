class StoreInfo < ActiveRecord::Base
  include BaseModel

  belongs_to :store

  belongs_to :info_category

  scope :normal, ->{ where(using: true) }
  scope :by_category, -> (category) { where(info_category_id: category) }
  scope :of_store, -> (store) { where(store: store) }

  def self.address(category)
    (self.by_category(category).normal.first || NullObject.new).value
  end

  def to_history!
    update(using: false)
  end
end
