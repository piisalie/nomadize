require 'nomadize'

namespace :db do

  desc 'Create database using name in {appdir}/config/database.yml'
  task :create do
    Nomadize.create_database
  end

  desc 'drop database using name in {appdir}/config/database.yml'
  task :drop do
    Nomadize.drop_database
  end

  desc 'Generate a migration template file in {appdir}/db/migrations/'
  task :new_migration, [:migration_name] do |_, args|
    Nomadize.generate_template_migration_file(args.migration_name)
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
  task :rollback, :steps do |_, args|
    count = args.steps || 1
    Nomadize.rollback(count)
  end

end
