class UpdateStoreService
  include Serviceable

  BASIC_INFO = "基本信息"

  def initialize(store, store_infos)
    @store = store
    @store_infos = store_infos
    @basic_info = InfoCategory.find_by_name(BASIC_INFO)
  end

  def call
    @store.transaction do
      @store.save!
      create_store_infos
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def create_store_infos
      InfoCategory.where(parent_id: @basic_info.id).each do |category|
        (category.store_infos.of_store(@store).normal.last || NullObject.new).to_history!
        category.store_infos.create(value: @store_infos.send("category_#{category.id}"), store: @store)
      end
  end
end
