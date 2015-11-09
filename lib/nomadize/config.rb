require 'yaml'

module Nomadize
  class Config
    def self.database_name
      open_config_file.fetch("db_name")
    end

    def self.open_config_file
      File.open('config/database.yml') { |f| YAML.load(f) }
    end
  end
end
