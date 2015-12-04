require 'nomadize'
require 'nomadize/help'

namespace :db do

  desc Nomadize.help.fetch(:create)
  task :create do
    Nomadize.create_database
  end

  desc Nomadize.help.fetch(:drop)
  task :drop do
    Nomadize.drop_database
  end

  desc Nomadize.help.fetch(:new_migration)
  task :new_migration, [:migration_name] do |_, args|
    Nomadize.generate_template_migration_file(args.migration_name)
  end

  desc Nomadize.help.fetch(:migrate)
  task :migrate do
    Nomadize.run_migrations
  end

  desc Nomadize.help.fetch(:status)
  task :status do
    Nomadize.status
  end

  desc Nomadize.help.fetch(:rollback)
  task :rollback, :steps do |_, args|
    count = args.steps || 1
    Nomadize.rollback(count)
  end

  desc Nomadize.help.fetch(:generate_template_config)
  task :generate_template_config do
    Nomadize.generate_template_config
    puts 'Config created in config/database.yml'
  end

end
