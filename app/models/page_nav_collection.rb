class PageNavCollection
  def initialize(navs = [])
    @navs = navs.map do |nav|
      PageNav.new(nav)
    end
  end

  def self.to_nav(navs = [])
    self.new(navs).to_nav
  end

  def to_nav
    @navs.map(&:to_nav).join("").html_safe
  end
end
