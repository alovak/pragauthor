namespace :vendors do
  task :import => :environment do
    Vendor.import
  end
end

