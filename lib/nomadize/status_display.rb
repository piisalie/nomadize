module Nomadize
  class StatusDisplay

    attr_reader :files, :records
    private     :files, :records

    def initialize(files:, records:)
      @files   = files.map { |file| file.merge!(status: records.include?(file[:filename]) ? "up" : "down") }
      @records = records
    end

    def titlebar
      "filename".ljust(lsize) + " | " + "status".rjust(rsize)
    end

    def divider
      "-" * titlebar.size
    end

    def migrations
      sorted_migrations.map do |migration|
        migration[:filename].ljust(lsize) + " | " + migration[:status].to_s.rjust(rsize)
      end.to_enum
    end

    private

    def sorted_migrations
      files.sort_by { |file| file[:filename] }
    end

    def rsize
      7
    end

    def lsize
      @lsize ||= files.map { |file| file[:filename] }.map(&:size).max
    end

  end
end
