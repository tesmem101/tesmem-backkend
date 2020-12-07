RAILS_ENV=production
# 1) Installing missing gems
bundle install
# 2) Precmpining Assets
bundle exec rake assets:precompile #RAILS_ENV=${RAILS_ENV}
# 3) Stop Puma Server
# kill -9 $(lsof -i tcp:3000 -t)
PID=`pgrep -f '^([^ ]*/)?puma '`
kill -9 $PID

# 4) Database
bundle exec rake db:migrate

# 5) Start Puma Server
puma -C config/puma.rb -e ${RAILS_ENV} -d
