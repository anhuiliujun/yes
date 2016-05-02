class Agent < ActiveRecord::Base
  belongs_to :staffer
  
  has_many :agent_payments, dependent: :destroy

  accepts_nested_attributes_for :agent_payments
end
