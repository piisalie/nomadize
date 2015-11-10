$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'nomadize'

require 'minitest/autorun'
require 'nomadize/pg_wrapper'
TEST_DB_NAME = 'nomadize_migrator_test'

def setup_database
  pg = PG.connect(dbname: 'postgres')
  if db_exists?(pg)
    db = Nomadize::PGWrapper.new(PG.connect(dbname: TEST_DB_NAME))
    db.exec("SET client_min_messages TO WARNING;")
    db.exec("DROP SCHEMA public CASCADE;
               CREATE SCHEMA public;")
    db.create_schema_migrations_table
    db
  else
    pg.exec("CREATE DATABASE $1;", [ TEST_DB_NAME ])
    db = Nomadize::PGWrapper.new(PG.connect(dbname: TEST_DB_NAME))
    db.create_schema_migrations_table
  end
end

def db_exists?(pg)
  result = pg.exec("SELECT EXISTS(
                             SELECT * FROM pg_database
                               WHERE datname = $1);", [ TEST_DB_NAME ]).to_a.first
  result.fetch("exists") == "t"
end


def check_for_table?(name, db)
  result = db.exec("SELECT EXISTS(SELECT * FROM information_schema.tables
           WHERE table_name = $1);", [ name ]).to_a.first
  result.fetch("exists") == "t"
end
