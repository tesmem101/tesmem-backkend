ActiveAdmin.register Design, as: "DesignDashboard" do
    menu parent: :dashboards, :label => "Design"
    actions :all, except: [:new, :edit, :edit, :destroy]
    # filter :role, as: :select, collection: User.roles.select {|k,v| ['designer', 'lead_designer'].include?(k)}
    # filter :created_at, label: 'Joining Date'

    # order_by(:designs_count) do |order_clause|
    #     ['number_of_designs', order_clause.order].join(' ')
    # end

    # order_by :number_of_approved_designs
      

    # controller do

    # end

    index do
        column :id
    end
end