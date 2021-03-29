class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role == 'super_admin'
      can :manage, :all
    elsif user.role == 'admin'
      can :manage, :all    
    # elsif user.role == 'designer'
    #   can :manage, :all
    #   cannot [:new, :create, :update, :destroy], User 
    elsif user.role == 'lead_designer'
      can :manage, :all
      cannot :manage, [User, Category, Container, Design, Folder, FormattedText, Image, SortReservedIcon, Upload]
    else
      can :read, :all
    end
  end
end
