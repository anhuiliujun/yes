class Mis::SoftwaresController < Mis::BaseController
  include StoreRenewalAble
  before_action :set_nav, only: [:index, :new, :edit, :show]

  def renewal_type
    0
  end

  def url
    mis_softwares_path
  end

  def target_name
    '软件续费'
  end

  def order_by
    'expired_at'
  end

  private

    def set_nav
      url = request.path
      url = "#{url}?store_id=#{@store.id}" if @store
      @page_nav = PageNavCollection.to_nav(
        [
          {name: '费用管理', url: 'javascript:void(0)', root: true},
          {name: '软件续费', url: mis_softwares_path},
          {name: Setting.action.send(request[:action]), url: url}
        ]
      )
    end
end
