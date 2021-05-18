ActiveAdmin.register_page "Statistics" do
  menu priority: 0
  content do

    columns :class => 'column--left' do
      # debugger
      columns :style => 'display: flex; margin: 20px;' do
        column do
          panel "Total Login today" do
            today = Time.zone.now.beginning_of_day
            h2 Visit.where("created_at >= ?", today).count
          end
        end

        column do
          panel "Total Login this month" do
            beginning_of_month = Time.zone.now.beginning_of_month
            h2 Visit.where("created_at >= ?", beginning_of_month).count
          end
        end

        column do
          panel "Total Login previous month" do
            start_date = Time.now.beginning_of_month - 1.month
            end_date = Time.now.end_of_month - 1.month
            h2 Visit.where(:created_at => start_date..end_date).count
          end
        end

      end

      columns :style => 'display: flex; margin: 20px;' do

        column do
          panel "Total Registered today" do
            today = Time.zone.now.beginning_of_day
            h2 User.where("created_at >= ?", today).count
          end
        end

        column do
          panel "Total Registered this month" do
            beginning_of_month = Time.zone.now.beginning_of_month
            h2 User.where("created_at >= ?", beginning_of_month).count
          end
        end

        column do
          panel "Total Registered previous month" do
            start_date = Time.now.beginning_of_month - 1.month
            end_date = Time.now.end_of_month - 1.month
            h2 User.where(:created_at => start_date..end_date).count
          end
        end

      end
    end

    columns :class => 'column--right' do

      column do
        panel "Search Panel" do
          div do
            render 'statistics', {selected_user: params[:user_id]}   
          end
        end
      end
    end


  end
end
