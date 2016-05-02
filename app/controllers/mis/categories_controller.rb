class Mis::CategoriesController < Mis::BaseController
  before_action :set_type, only: [:index, :create]
  before_action :set_page_head, :set_search_url
  before_action :set_nav, only: [:index, :new, :edit, :show]

  load_and_authorize_resource
  skip_authorize_resource only: [:index]

  def index
    @q = Category.send(@type.to_sym).ransack(params[:q])
    @categories = @q.result(distinct: true).order(id: :asc).paginate(page: params[:page] || 1, per_page: 10)
    authorize! :read, @categories
  end

  def create
    category = "#{@type}_category".camelize.constantize.new(category_params)
    if category.save
      redirect_to mis_categories_path(type: @type), notice: "#{category.name}创建成功!"
    else
      redirect_to mis_categories_path(type: @type), alert: category.errors.full_messages.to_sentence
    end
  end

  def update
    category = Category.find(params[:id])
    if category.update(name: params[:name])
      render json: {notice: '修改成功!'}
    else
      render json: {notice: category.errors.full_messages.to_sentence}
    end
  end

  private

    def set_type
      @type = params[:type] ||= 'service'
    end

    def set_page_head
      @page_head = "类别"
    end

    def set_nav
      @page_nav = PageNavCollection.to_nav(
        [
          {name: '类别设置', url: 'javascript:void(0)', root: true},
          {name: (@type == 'service' ? '服务类别' : '销售类别'), url: mis_categories_path(type: @type)},
          {name: Setting.action.send(request[:action]), url: "#{request.path}?type=#{@type}"}
        ]
      )
    end

    def category_params
      params.require(:category).permit(:name)
    end

    def set_search_url
      @search_url = mis_categories_path
    end
end
