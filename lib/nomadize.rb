require "nomadize/version"
require 'nomadize/migration_loader'
require 'nomadize/migration'
require 'nomadize/migrator'
require 'nomadize/config'
require 'nomadize/status_display'
require 'pg'

module Nomadize

  def self.run_migrations
    db = PG.connect(dbname: Nomadize::Config.database_name)
    migration_files = Nomadize::MigrationLoader.new(path: Nomadize::Config.migrations_path).migrations
    migrations =  migration_files.map do |migration|
      Nomadize::Migration.new(migration)
    end

    migrator = Nomadize::Migrator.new(db: db, migrations: migrations)
    migrator.run
    db
  end

  def self.create_database
    name = Nomadize::Config.database_name
    system("createdb --echo #{name}")
    db = PG.connect(dbname: name)
    db.exec("CREATE TABLE schema_migrations (filename TEXT NOT NULL);")
    db
  end

  def self.status
    name            = Config.database_name
    migrations_path = Config.migrations_path
    files           = MigrationLoader.new(path: migrations_path).migrations
    db              = PG.connect(dbname: name)
    records = db.exec("SELECT filename FROM schema_migrations;").to_a.flat_map(&:values)

    display = StatusDisplay.new(files: files, records: records)

    puts display.titlebar
    puts display.divider
    display.migrations.each do |row|
      puts row
    end
  end

end
