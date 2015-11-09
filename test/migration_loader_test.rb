require 'test_helper'
require 'tmpdir'

require 'nomadize/migration_loader'

class MigrationLoaderTest < Minitest::Test

  def test_it_loads_migration_files
    filename = "20151109094511_create_test_table.yml"
    up       = "CREATE TABLE test (example TEXT NOT NULL);"
    down     = "DROP TABLE test;"

    Dir.mktmpdir('nomadize_migration_loader_test') do |path|
      File.open(File.join(path, filename), "w") { |f|
        f.write(YAML.dump( { up:   up,
                            down: down } ))
      }
      loader = Nomadize::MigrationLoader.new(path: path)
      assert_equal 1,        loader.migrations.count
      assert_equal down,     loader.migrations.first[:down]
      assert_equal up,       loader.migrations.first[:up]
      assert_equal filename, loader.migrations.first[:filename]
    end
  end

end
