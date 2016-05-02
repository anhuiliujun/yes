class Ability
  include CanCan::Ability

  def initialize(user)
      user ||= Staffer.new # guest user (not logged in)
      if user.role_id == 1
        can :manage, :all
      else
        can :manage, Staffer, :id => user.id
        can :manage, [Store, StoreChain], :creator_id => user.id
        # can :manage, StoreChain, :creator_id => user.id
      end
  end
end
