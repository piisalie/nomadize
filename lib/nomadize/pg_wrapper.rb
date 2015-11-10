require 'forwardable'

module Nomadize
  class PGWrapper
    extend Forwardable
    attr_reader :pg

    def initialize(pg)
      @pg = pg
    end

    def_delegators :pg, :exec

    def create_schema_migrations_table
      exec("CREATE TABLE schema_migrations (filename TEXT NOT NULL);")
    end

    def retrieve_all_migration_filenames
      exec("SELECT filename FROM schema_migrations;").to_a.flat_map(&:values)
    end

    def insert_migration_filename(filename)
      exec("INSERT INTO schema_migrations (filename) VALUES ($1);", [ filename ])
    end

    def remove_migration_filename(filename)
      exec("DELETE FROM schema_migrations WHERE filename = $1;", [ filename ])
    end

  end
end
