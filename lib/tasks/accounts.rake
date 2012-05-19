namespace :accounts do
  task :sync => :environment do
    Account.all.each {|a| a.sync }
  end
end

