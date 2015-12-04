module Nomadize
  class Migration
    attr_reader :up, :down, :filename
    private     :up, :down

    def initialize(up:, down:, filename:)
      @up       = up
      @down     = down
      @filename = filename
    end

    def run(db)
      db.exec(up)
      db.insert_migration_filename(filename)
      filename
    end

    def rollback(db)
      db.exec(down)
      db.remove_migration_filename(filename)
      filename
    end

  end
end
