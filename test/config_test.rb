require 'test_helper'
require 'tmpdir'

require 'nomadize/config'

class ConfigTest < Minitest::Test

  def config_contents
    { 'migrations_path' => 'db/migrations',
      'development'     => { dbname: 'db_dev' },
      'test'            => { dbname: 'db_test'},
    }
  end

  def test_caches_config_file
    build_and_load_fake_config_file
    assert_equal config_contents, Nomadize::Config.config_file
  end

  def test_has_an_env
    assert_nil ENV['RACK_ENV']
    assert_equal 'development', Nomadize::Config.env

    ENV['RACK_ENV'] = 'testing'
    assert_equal 'testing', Nomadize::Config.env
    ENV.delete('RACK_ENV')
  end

  def test_switches_db_config_with_env
    build_and_load_fake_config_file
    assert_nil ENV['RACK_ENV']
    assert_equal 'development', Nomadize::Config.env
    assert_equal({dbname: 'db_dev'}, Nomadize::Config.db_connection_info)

    ENV['RACK_ENV'] = 'test'
    assert_equal({dbname: 'db_test'}, Nomadize::Config.db_connection_info)
    ENV.delete('RACK_ENV')
  end

  def build_and_load_fake_config_file
    Dir.mktmpdir('nomadize_config_test') do |path|
      File.open(File.join(path, 'database.yml'), "w") { |f| f.write(YAML.dump(config_contents)) }
      Nomadize::Config.config_file(File.join(path, 'database.yml'))
    end
  end

end
