class Mis::MessagesController < Mis::BaseController
  include StoreRenewalAble
  before_action :set_nav, only: [:index, :new, :edit, :show]

  def renewal_type
    1
  end

  def url
    mis_messages_path
  end

  def target_name
    '短信续费'
  end

  def order_by
    'balance'
  end

  private

    def set_nav
      url = request.path
      url = "#{url}?store_id=#{@store.id}" if @store
      @page_nav = PageNavCollection.to_nav(
        [
          {name: '费用管理', url: 'javascript:void(0)', root: true},
          {name: '短信续费', url: mis_messages_path},
          {name: Setting.action.send(request[:action]), url: url}
        ]
      )
    end
end
