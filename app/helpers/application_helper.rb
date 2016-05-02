module ApplicationHelper
  # 生成对应角色的操作菜单
  # <div class="panel_title"><a href="javascript:void(0)">系统设置</a></div>
  # <ul class="list"><li><a href="/admin/staffers">管理员</a></li><li><a href="/admin/roles">权限角色</a></li></ul>
  def staffer_menus(staffer)
    return "" unless staffer.present? #&& staffer.allowed?

    html = ""
    Menu.instance[:menu].each do |m1|
      next unless staffer.admin? || m1["roles"].include?(staffer.role.try(:abbrev))
      html += "<div class='panel_title'><a href='javascript:void(0)'>#{m1["name"]}</a></div>"
      html += "<ul class='list'>"
      m1["menus"].each do |m2|
        html += "<li><a href='#{m2["href"]}' #{"rel='#{m2["rel"]}'" if m2["rel"]} #{"data-confirm='#{m2["data-confirm"]}'" if m2["data-confirm"]} #{"data-method='#{m2["data-method"]}'" if m2["data-method"]}>#{m2["name"]}</a></li>"
      end
      html += "</ul>"
    end
    html.html_safe
  end

  def notice_tag
    content_tag(:div, flash[:notice], class: 'notice')
  end

  def json_for(target)
    ActiveModel::ArraySerializer.new(target).to_json
  end

  def store_with_info(store_id, category)
      infos = InfoCategory.where(parent_id: InfoCategory.find_by_name(category).id)
      StoreInfo.where(store_id: store_id, info_category_id: infos.pluck(:id)).present?
  end

  def store_info_navs(store)
    category_to_path = {
      '设施信息' => :ficilities_infos,
      '网络信息' => :internet_infos,
      '财务信息' => :financial_infos,
      '营销账号' => :account_infos
    }

      html = ""
      html += "<li><a href='/mis/stores/#{store}'"
      html += "class='active'" if params[:controller].split('/').last.include?("store")
      html += ">基本信息</a></li>"
      category_to_path.each do |category, path|

        active = 'active' if path.to_s.pluralize == params[:controller].split('/').last
        html += "<li>"
        html += "<a "
        html += store_with_info(store, category) ? "href='/mis/stores/#{store}/#{path.to_s}'" : "href='/mis/stores/#{store}/#{path.to_s}/new'"
        html += "class='#{active}'"
        html += " >"
        html += "#{category}</a> "
        html += "</li>"
    end
     html.html_safe
  end


  def agent_basic_with_payments_nav(staffer)
    nav = { '基本信息' => :agents, '消费记录' => :agent_payments }
    html = ""
    nav.each do |key,value|
      active = 'active' if value.to_s.pluralize == params[:controller].split('/').last
      html += "<li><a "
      html += key == '基本信息' ? "href='/mis/agents/#{staffer.id}'" : "href='/mis/staffers/#{staffer.id}/agent_payments'"
      html += "class='#{active}'>#{key}</a></li>"
    end
    html.html_safe
  end
end
