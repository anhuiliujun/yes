class Category < ActiveRecord::Base
  scope :service, ->{ where(type: 'ServiceCategory') }
  scope :sale, ->{ where(type: 'SaleCategory') }

  validates :name, presence: true, uniqueness: {scope: 'type'}
end
