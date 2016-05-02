class InfoCategory < ActiveRecord::Base
  has_many :store_infos
  belongs_to :parent, class_name: 'InfoCategory', foreign_key: 'parent_id', dependent: :destroy
  has_many :children, class_name: 'InfoCategory', foreign_key: 'parent_id'

  validates :name, presence: true
  TYPE = { mobile: '联系电话' }

  PRIMARY = { ficilities:  '设施信息',
              internet:  '网络信息',
              financial:  '财务信息',
              account:  '营销账号' ,
              basic:  '基本信息'       }

  scope :category, ->{ where(parent_id: nil) }

  scope :sub_ficilities, -> { joins(:parent).where(parents_info_categories: { name: PRIMARY[:ficilities] }) }

  scope :sub_internet, -> { joins(:parent).where(parents_info_categories: { name: PRIMARY[:internet] }) }

  scope :sub_account, -> { joins(:parent).where(parents_info_categories: { name: PRIMARY[:account]}) }

  scope :sub_financial, -> { joins(:parent).where(parents_info_categories: { name: PRIMARY[:financial] }) }

  scope :sub_basic, -> { joins(:parent).where(parents_info_categories: { name: PRIMARY[:basic] }) }

  scope :mobile, -> { where(name: TYPE[:mobile]) }

end
