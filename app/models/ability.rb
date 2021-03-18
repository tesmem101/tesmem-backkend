class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role == 'super_admin'
      can :manage, :all
    elsif user.role == 'admin'
      can :manage, :all    
    elsif user.role == 'designer'
      can :manage, :all
      cannot [:new, :create, :update, :destroy], User 
    else
      can :read, :all
    end
  end
end
