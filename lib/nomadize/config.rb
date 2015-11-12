require 'yaml'
require 'pg'
require 'nomadize/pg_wrapper'

module Nomadize
  class Config

    def self.env
      ENV.fetch('RACK_ENV', 'development')
    end

    def self.db_connection_info
      config_file.fetch(env)
    end

    def self.database_name
      db_connection_info.fetch(:dbname)
    end

    def self.migrations_path
      config_file.fetch('migrations_path', 'db/migrations')
    end

    def self.config_file(path = 'config/database.yml')
      @file ||= File.open(path) { |f| YAML.load(f) }
    end

    def self.db
      PGWrapper.new(PG.connect(db_connection_info))
    end

  end
end
