module Nomadize
  class Migrator
    attr_reader :migrations, :db
    private     :migrations, :db

    def initialize(db:, migrations:)
      @migrations = migrations
      @db         = db
      create_migrations_table
    end

    def run
      pending.map { |migration| migration.run(db) }
    end

    def pending
      sorted_by_timestamp.select do |migration|
        !recorded_migrations.include?(migration.filename)
      end
    end

    private

    def sorted_by_timestamp
      migrations.sort_by { |migration| migration.filename }
    end

    def create_migrations_table
      db.exec("CREATE TABLE IF NOT EXISTS schema_migrations (filename TEXT NOT NULL);")
    end

    def recorded_migrations
      db.exec("SELECT filename FROM schema_migrations;").values.flatten
    end

  end
end
