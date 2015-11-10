require 'nomadize/version'
require 'nomadize/migration_loader'
require 'nomadize/migration'
require 'nomadize/migrator'
require 'nomadize/config'
require 'nomadize/status_display'

module Nomadize

  def self.run_migrations
    db = Config.db
    migration_files = MigrationLoader.new(path: Config.migrations_path).migrations
    migrations =  migration_files.map do |migration|
      Migration.new(migration)
    end

    migrator = Migrator.new(db: db, migrations: migrations)
    migrator.run
    db
  end

  def self.create_database
    system("createdb --echo #{Config.database_name}")
    db = Config.db
    db.exec("CREATE TABLE schema_migrations (filename TEXT NOT NULL);")
    db
  end

  def self.status
    files           = MigrationLoader.new(path: Config.migrations_path).migrations
    db              = Config.db
    records         = db.exec("SELECT filename FROM schema_migrations;").to_a.flat_map(&:values)

    display = StatusDisplay.new(files: files, records: records)

    puts display.titlebar
    puts display.divider
    display.migrations.each do |row|
      puts row
    end
  end

  def self.rollback(count = 1)
    db = Config.db
    migration_files = MigrationLoader.new(path: Config.migrations_path).migrations
    migrations =  migration_files.map do |migration|
      Migration.new(migration)
    end

    migrator = Migrator.new(db: db, migrations: migrations)
    migrator.rollback(count)
    db
  end

end
