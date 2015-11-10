require 'nomadize/version'
require 'nomadize/migration_loader'
require 'nomadize/migration'
require 'nomadize/migrator'
require 'nomadize/config'
require 'nomadize/status_display'

module Nomadize

  def self.run_migrations
    db              = Config.db
    migration_files = MigrationLoader.new(path: Config.migrations_path).migrations
    migrations      = migration_files.map { |migration| Migration.new(migration) }
    migrator        = Migrator.new(db: db, migrations: migrations)

    migrator.run
    db
  end

  def self.create_database
    system("createdb --echo #{Config.database_name}")
    db = Config.db
    db.create_schema_migrations_table
    db
  end

  def self.status
    files   = MigrationLoader.new(path: Config.migrations_path).migrations
    db      = Config.db
    records = db.retrieve_all_migration_filenames

    display = StatusDisplay.new(files: files, records: records)

    puts display.titlebar
    puts display.divider
    display.migrations.each do |row|
      puts row
    end
  end

  def self.rollback(count = 1)
    db              = Config.db
    migration_files = MigrationLoader.new(path: Config.migrations_path).migrations
    migrations      = migration_files.map { |migration| Migration.new(migration) }
    migrator        = Migrator.new(db: db, migrations: migrations)

    migrator.rollback(count)
    db
  end

end
