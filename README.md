# Nomadize

Some utilities for managing migrations with postgres (without requiring an entire ORM)

This is nowhere near done; still needs:
- [ ] an actual config setup / object
- [ ] sql cleaning (getting rid of the interpolation)
- [ ] to display migration status
- [ ] migration rollbacks
- [ ] transactions / error handling

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nomadize'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nomadize

## Usage

Add `require 'nomadize/tasks'` to your rake file, and enjoy helpful new rake
tasks such as:

`rake db:create` - creates a database and a schema_migrations table

`rake db:drop`   - dumps your poor poor database

`rake db:new_migration[migration_name]` - creates a timestamped migration file in db/migrations/ just fill in the details.

`rake db:migrate` - runs migrations found in db/migrations that have not been run yet

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/piisalie/nomadize. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
