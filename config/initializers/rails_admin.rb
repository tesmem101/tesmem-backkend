RailsAdmin.config do |config|
  config.excluded_models = ["StockTag", "UserToken", "TemplateTag"]

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == CancanCan ==
  config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.model 'SortReservedIcon' do
    update do
      
    end
  end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new do
      except ['Design', 'SortReservedIcon', 'FormattedText']
    end
    export do
      except ['SortReservedIcon']
    end
    
    bulk_delete do
      except ['SortReservedIcon']
    end
    show
    edit
    delete do
      except ['SortReservedIcon']
    end
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
