require 'yaml'
require 'pg'
require 'uri'
require 'nomadize/pg_wrapper'

module Nomadize
  class Config

    def self.env
      ENV.fetch('RACK_ENV', 'development')
    end

    def self.db_connection_info
      database_url_config || config_file.fetch(env)
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

    private

    def self.database_url_config
      ENV['DATABASE_URL'] ? parse(ENV['DATABASE_URL']) : nil
    end

    def self.parse(database_url)
      uri = URI.parse(database_url)
      config = { }
      config[:port]     = uri.port               if uri.port
      config[:user]     = uri.user               if uri.user
      config[:host]     = uri.host               if uri.host
      config[:password] = uri.password           if uri.password
      config[:dbname]   = uri.path.sub("/", "")  if uri.path
      config
    end

  end
end
