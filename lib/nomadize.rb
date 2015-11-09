require "nomadize/version"
require 'nomadize/migration_loader'
require 'nomadize/migration'
require 'nomadize/migrator'
require 'nomadize/config'
require 'pg'

module Nomadize

  def self.run_migrations
    db = PG.connect(dbname: Nomadize::Config.database_name)
    migration_files = Nomadize::MigrationLoader.new(path: "db/migrations").migrations
    migrations =  migration_files.map do |migration|
      Nomadize::Migration.new(migration) end

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

end
