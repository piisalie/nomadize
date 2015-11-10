module Nomadize
  class Migrator
    attr_reader :migrations, :db
    private     :migrations, :db

    def initialize(db:, migrations:)
      @migrations = migrations
      @db         = db
    end

    def run
      pending.map { |migration| migration.run(db) }
    end

    def rollback(count)
      done[-count..-1].reverse.map { |migration| migration.rollback(db) }
    end

    def pending
      sorted_by_timestamp.select do |migration|
        !recorded_migrations.include?(migration.filename)
      end
    end

    private

    def done
      sorted_by_timestamp.select do |migration|
        recorded_migrations.include?(migration.filename)
      end
    end

    def sorted_by_timestamp
      migrations.sort_by { |migration| migration.filename }
    end

    def recorded_migrations
      db.retrieve_all_migration_filenames
    end

  end
end
