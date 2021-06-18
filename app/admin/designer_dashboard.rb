ActiveAdmin.register User, as: "DesignerDashboard" do
    menu parent: :dashboards
    actions :all, except: [:new, :edit, :edit, :destroy]
    filter :role, as: :select, collection: User.roles.select {|k,v| ['designer', 'lead_designer'].include?(k)}
    filter :created_at, label: 'Joining Date'

    order_by(:designs_count) do |order_clause|
        ['number_of_designs', order_clause.order].join(' ')
    end

    order_by :number_of_approved_designs
      

    controller do
        def scoped_collection
            User.joins("left join designs on designs.user_id = users.id").where(role: ['designer', 'lead_designer']).group("users.id").select("users.*, count(designs.id) as number_of_designs")
        end

    end

    index do
        column :id
        column 'Name' do |user|
            user.first_name
        end
        column :role
        column 'Joining Date' do |user|
            user.created_at.to_date
        end
        column :number_of_designs, sortable: :designs_count
        
        column 'Number of approved designs', sortable: :designs_count do |user|
            user.designs.joins(:designer).where("designers.approved = ? ", true).count
        end

        column 'Number of rejected designs', sortable: :designs_count do |user|
            user.designs.joins(:designer).where("designers.approved = ? ", false).count
        end

        column 'Number of pending designs', sortable: :designs_count do |user|
            user.designs.count - user.designs.joins(:designer).count
        end


        column 'Rate per design' do
            'Coming Soon'
        end

        column 'Paid amount' do
            'Coming Soon'
        end

        column 'Number of used designs' do |user|
            'Coming soon'
        end

    end
end