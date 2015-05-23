require './app'

task :default => :migrate

desc "Run migrations"
task :migrate do
  ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
end

desc "Run rollback"
task :rollback do
  ActiveRecord::Migrator.rollback('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
end