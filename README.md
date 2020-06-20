# PSQL Toys

Toys template for actions with PostgreSQL, like dumps.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'psql_toys'
```

And then execute:

```shell
bundle install
```

Or install it yourself as:

```shell
gem install psql_toys
```

## Usage

```ruby
require 'psql_toys'
expand PSQLToys::Template,
  db_config_proc: (proc do
    require "#{context_directory}/config/config"
    MyProject::Application.config[:database]
  end),
  db_connection_proc: (proc do
    require "#{context_directory}/config/config"
    MyProject::Application.db_connection
  end),
  db_extensions: %w[citext pgcrypto] # this is default, can be changed

# `database` namespace created
# aliases are optional, but handful
alias_tool :db, :database
```

## Development

After checking out the repo, run `bundle install` to install dependencies.
Then, run `bundle exec rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`,
and then run `bundle exec rake release`, which will create a git tag
for the version, push git commits and tags, and push the `.gem` file
to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/AlexWayfer/psql_toys).

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
