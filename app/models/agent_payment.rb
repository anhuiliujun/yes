class AgentPayment < ActiveRecord::Base
  belongs_to :agent
  belongs_to :staffer, foreign_key: 'creator_id'
end
