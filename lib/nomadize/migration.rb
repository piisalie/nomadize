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
      db.exec("INSERT INTO schema_migrations (filename) VALUES ($1);", [ filename ])
    end

    def rollback(db)
      db.exec(down)
      db.exec("DELETE FROM schema_migrations WHERE filename = $1;", [ filename ])
    end

  end
end
