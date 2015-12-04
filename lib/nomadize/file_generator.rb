require 'fileutils'
require 'yaml'

module Nomadize
  class FileGenerator
    attr_reader :path, :name, :timestamp
    private     :path, :name, :timestamp

    def initialize(path:, name:, timestamp: DateTime.now.new_offset(0).strftime("%Y%m%d%H%M%S"))
      @path      = path
      @name      = name
      @timestamp = timestamp
    end

    def save
      FileUtils.mkdir_p path unless File.exists?(path)
      migration_file = File.join(path, timestamped_name)
      File.open(File.join(path, timestamped_name), "w") { |f| f.write(template_content) }
      migration_file
    end

    private

    def timestamped_name
      "#{timestamp}_#{name}.yml"
    end

    def template_content
      YAML.dump( {up: "", down: "" })
    end

  end
end
