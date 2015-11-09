require 'pg'

module Nomadize
  class Migrator
    attr_reader :migrations, :db
    private     :migrations, :db

    def initialize(db:, migrations:)
      @migrations = migrations
      @db         = db
    end

    def run
      create_migrations_table
    end

    private

    def create_migrations_table
      db.exec("CREATE TABLE IF NOT EXISTS schema_migrations (filename VARCHAR);")
    end

  end
end
