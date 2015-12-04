require 'test_helper'
require 'tmpdir'

require 'nomadize/config'

class ConfigTest < Minitest::Test

  def config_contents
    {
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

    ensure
      ENV.delete('RACK_ENV')
  end

  def test_switches_db_config_with_env
    build_and_load_fake_config_file
    assert_nil ENV['RACK_ENV']
    assert_equal 'development', Nomadize::Config.env
    assert_equal({dbname: 'db_dev'}, Nomadize::Config.db_connection_info)

    ENV['RACK_ENV'] = 'test'
    assert_equal({dbname: 'db_test'}, Nomadize::Config.db_connection_info)

    ensure
      ENV.delete('RACK_ENV')
  end

  def test_has_default_migrations_path
    build_and_load_fake_config_file
    assert_equal 'db/migrations', Nomadize::Config.migrations_path
  end

  def test_database_url_env_var_overrides_config_file
    build_and_load_fake_config_file
    config = {
      dbname:   'database-name',
      port:     1337,
      user:     'user1',
      password: 'supersecure',
      host:     'somehost'
    }

    assert_nil ENV['DATABASE_URL']
    ENV['DATABASE_URL'] = "postgres://#{config[:user]}:#{config[:password]}@#{config[:host]}:#{config[:port]}/#{config[:dbname]}"

    assert_equal config, Nomadize::Config.db_connection_info

    ensure
      ENV.delete('DATABASE_URL')
  end

  def build_and_load_fake_config_file
    Dir.mktmpdir('nomadize_config_test') do |path|
      File.open(File.join(path, 'database.yml'), "w") { |f| f.write(YAML.dump(config_contents)) }
      Nomadize::Config.config_file(File.join(path, 'database.yml'))
    end
  end

end
