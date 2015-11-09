require 'fileutils'

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
      File.open(File.join(path, timestamped_name), "w") { }
    end

    private

    def timestamped_name
      "#{timestamp}_#{name}.yml"
    end

  end
end
