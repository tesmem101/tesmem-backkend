class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role == 'admin'
      can :access, :rails_admin
      can :manage, :dashboard
      can :manage, Category
      can :manage, SubCategory
      can :manage, Stock
      can :manage, Designer
      can :manage, Tag
      can :read, Design
    end
    if user.role == 'designer'
      can :access, :rails_admin
      can :manage, :dashboard
      can :manage, Category
      can :manage, SubCategory
      can :manage, Stock
      can :manage, Designer
      can :manage, Tag
      can :read, Design
    end
    if user.role == 'super_admin'
      can :manage, :all
      can :access, :rails_admin       # only allow admin users to access Rails Admin
      can :manage, :dashboard         # allow access to dashboard
    end
    if user.role == 'user'
      can :access, :rails_admin
      can :manage, :dashboard
    end
  end
end
