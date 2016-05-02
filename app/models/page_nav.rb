class PageNav
  delegate :link_to, to: :helper

  def initialize(options = {})
    @root = options.fetch(:root, false)
    @name = options[:name]
    @url = options[:url]
  end

  def to_nav
    html = "<li class='font-14'>"
    html += "<i class='fa fa-angle-double-right'></i>" unless root?
    html += "#{ link_to @name, @url, class: 'color-93CEE6' }</li>"
  end

  private
  def root?
    @root
  end

  def helper
    ActionController::Base.helpers
  end
end
