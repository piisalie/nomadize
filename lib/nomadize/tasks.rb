require 'nomadize'

namespace :db do

  desc 'Create database using name in {appdir}/config/database.yml'
  task :create do
    Nomadize.create_database
  end

  desc 'drop database using name in {appdir}/config/database.yml'
  task :drop do
    require 'nomadize/config'
    name = Nomadize::Config.database_name
    system("dropdb --echo #{name}")
  end

  desc 'Generate a migration template file in {appdir}/db/migrations/'
  task :new_migration, [:migration_name] do |_, args|
    require 'nomadize/file_generator'
    Nomadize::FileGenerator.new(path: 'db/migrations', name: args.migration_name).save
  end

  desc 'Run migrations'
  task :migrate do
    Nomadize.run_migrations
  end

  desc 'view the status of known migrations'
  task :status do
    Nomadize.status
  end

  desc 'rollback migrations (default count: 1)'
  task :rollback, :count do |_, args|
    count = args.count || 1
    Nomadize.rollback(count)
  end

end
