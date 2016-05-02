class StoreInfos
  def self.build(options)
    options.each do |key, value|
      define_method "category_#{key}" do
        value[:value]
      end
    end
    self.new
  end
end
