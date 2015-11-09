namespace :db do

  desc 'Create database using name in {appdir}/config/database.yml'
  task :create do
    require 'nomadize/config'
    name = Nomadize::Config.database_name
    system("createdb --echo #{name}")
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
    require 'nomadize'
    Nomadize.run(migrations)
  end

end
