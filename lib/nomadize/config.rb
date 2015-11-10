require 'yaml'
require 'pg'

module Nomadize
  class Config

    def self.env
      ENV.fetch('RACK_ENV', 'development')
    end

    def self.connection_options
      config_file.fetch(env).fetch('db_options')
    end

    def self.db_connection_info
      config_file.fetch(env)
    end

    def self.database_name
      db_connection_info.fetch(:dbname)
    end

    def self.migrations_path
      config_file.fetch("migrations_path")
    end

    def self.config_file(path = 'config/database.yml')
      @file ||= File.open(path) { |f| YAML.load(f) }
    end

    def self.db
      PG.connect(db_connection_info)
    end

  end
end
