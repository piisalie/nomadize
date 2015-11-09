module Nomadize
  class StatusDisplay

    attr_reader :files, :records
    private     :files, :records

    def initialize(files:, records:)
      @files   = files
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

    def files_with_status
      files.map { |file|
        file.merge(status: calculate_status(file))
      }
    end

    def calculate_status(file)
      if records.include?(file[:filename])
        'up'
      else
        'down'
      end
    end

    def sorted_migrations
      migrations = files_with_status + migrations_without_files
      migrations.sort_by { |file| file[:filename] }
    end

    def migrations_without_files
      filenames = files.map { |file| file[:filename] }
      records.select { |record| !filenames.include?(record) }.map { |record|
        { filename: record, status: 'missing' }
      }
    end

    def rsize
      7
    end

    def lsize
      @lsize ||= sorted_migrations.map { |file| file[:filename] }.map(&:size).max
    end

  end
end
