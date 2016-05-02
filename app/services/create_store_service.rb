class CreateStoreService
  include Serviceable

  attr_reader :store, :store_chain

  BASIC_INFO = "基本信息"

  def initialize(store, store_infos, store_chain = nil)
    @store = store
    @store_infos = store_infos
    @store_chain = store_chain
    @basic_info = InfoCategory.find_by_name(BASIC_INFO)
  end

  def call
    @store.transaction do
      @store_chain ||= StoreChain.create
      @store.update!(store_chain: @store_chain)
      admin = @store.admin
      admin.update!(store: @store, store_chain: @store_chain)
      @store_chain.update!(chain_admin: admin,admin_store: @store, creator_id: @store.creator_id)  if @store.head_office?
      create_store_infos
      init_default_organizational_structure(@store)
      init_default_settlement_account(@store)
      init_default_depot(@store)
      send_create_store_msg(@store)
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error e.message
    false
  end

  def create_store_infos
    InfoCategory.where(parent_id: @basic_info.id).each(&store_info_creator)
  end

  def store_info_creator
    -> (info_category) {info_category.store_infos.create(value: @store_infos.send("category_#{info_category.id}"), store: @store)}
  end

  def init_default_organizational_structure(store)
    department = store.store_departments.create!(
      name: '默认部门',
      store_chain_id: store.store_chain_id,
      store_staff_id: store.admin_id
    )
    department.store_positions.create!(
      name: '默认职位',
      store_id: store.id,
      store_chain_id: store.store_chain_id,
      store_staff_id: store.admin_id
    )
  end

  def init_default_settlement_account(store)
    store
      .store_settlement_accounts
        .create name: '默认结算账户',
                store_chain_id: store.store_chain_id,
                store_staff_id: store.admin_id
  end

  def init_default_depot(store)
    store
      .store_depots
        .create name: '默认仓库',
                store_chain_id: store.store_chain_id,
                store_staff_id: store.admin_id,
                preferred: true,
                admin_ids: [store.admin_id]

  end

  def send_create_store_msg(store)
    SmsClient.publish(store.admin.phone_number, Setting.message.new_store)
  rescue Exception => e
    Rails.logger.error e.message
    true
  end
end
