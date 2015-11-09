require "nomadize/version"
require 'nomadize/migration_loader'
require 'nomadize/migration'
require 'nomadize/migrator'
require 'nomadize/config'
require 'pg'

module Nomadize

  def self.run_migrations
    db = PG.connect(dbname: Nomadize::Config.database_name)
    migrations =  Nomadize::MigrationLoader.new(path: "db/migrations").migrations.map { |migration|
      Nomadize::Migration.new(migration) }
    migrator = Nomadize::Migrator.new(db: db, migrations: migrations)
    migrator.run
  end

end
