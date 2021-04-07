class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role == 'super_admin'
      can :manage, :all
      cannot [:destroy], User
    elsif user.role == 'admin'
      can :manage, :all
      cannot [:destroy], User
    # elsif user.role == 'designer'
    #   can :manage, :all
    #   cannot [:new, :create, :update, :destroy], User 
    elsif user.role == 'lead_designer'
      can :manage, :all
      cannot :manage, [User, Category, SubCategory, Container, Design, Folder, FormattedText, Image, SortReservedIcon, Upload, Stock, Tag] 
    else
      can :read, :all
      cannot [:new, :create, :update, :destroy], :all
    end
  end
end
