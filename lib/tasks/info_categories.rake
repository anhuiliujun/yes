  namespace :info_categories do
    desc '导入门店初始的相关类别信息'
    task :init => :environment do
      categories = (YAML.load_file Rails.root.join("config", "info_categories.yml")).with_indifferent_access[:categories]
      categories.each do |c|
        parent = InfoCategory.create c.except(:sub_categories)
        c[:sub_categories].each {|sc| parent.children.create(sc)}
      end
  end
end
