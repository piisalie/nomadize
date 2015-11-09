require 'yaml'

module Nomadize
  class MigrationLoader
    attr_reader :path
    private     :path

    def initialize(path:)
      @path = path
    end

    def migrations
      filenames.map do |filename|
        File.open(filename, "r") { |f|
          YAML.load(f).merge(filename: File.basename(filename, ".yml"))
        }
      end
    end

    private

    def filenames
      Dir[File.join(path, '*.yml')]
    end
  end
end
