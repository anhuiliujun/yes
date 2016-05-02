class Mis::InfoCategoriesController < Mis::BaseController
	before_action :info_category,only:[:destroy,:edit,:update,:show]
	def new
		@info_category=InfoCategory.new
	end

	def create
		@info_category=InfoCategory.new(set_params)
		if @info_category.save
			redirect_to mis_info_categories_path
		else
			render 'new'
		end
	end
	
	def destroy
		@info_category.destroy
		redirect_to mis_info_categories_path
	end

	def edit

	end

	def update
		@info_category.update(set_params)
		redirect_to  mis_info_categories_path
	end

	def show
		@info_categories=InfoCategory.where(parent_id: params[:id])
	end

	def index
		@info_categories = InfoCategory.where(parent_id: nil).paginate(page: params[:page] || 1, per_page: params[:per_page] || 1)
	end

	def new_subtype
		@id=params[:id]
		@info_category=InfoCategory.new
	end

	private
	def info_category
		@info_category=InfoCategory.find(params[:id])
	end

	def set_params
		params.require(:info_category).permit(:name,:parent_id)
	end
end
