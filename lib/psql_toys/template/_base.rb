# frozen_string_literal: true

module PSQLToys
	class Template
		## Base class for templates
		class Base
			include Toys::Template

			attr_reader :application

			def initialize(application:)
				@application = application
			end

			on_expand do
				DB_DUMPS_DIR = "#{context_directory}/db/dumps"
			end

			private

			def require_application_config
				require "#{context_directory}/config/config"
			end

			def db_config
				return @db_config if defined?(@db_config)

				require_application_config

				@db_config = application.config[:database]
			end

			def db_connection
				return @db_connection if defined?(@db_connection)

				require_application_config

				@db_connection = application.db_connection
			end

			def db_access
				@db_access ||=
					{ '-U' => db_config[:user], '-h' => db_config[:host] }
						.compact.map { |key, value| "#{key} #{value}" }.join(' ')
			end

			def pgpass_line
				@pgpass_line ||=
					db_config
						.fetch_values(:host, :port, :database, :user, :password) { |_key| '*' }
						.join(':')
			end

			## Constants for DB

			DB_DUMP_FORMATS = %w[custom plain].freeze

			PGPASS_FILE = File.expand_path '~/.pgpass'

			DB_EXTENSIONS = %w[citext pgcrypto].freeze

			def update_pgpass
				pgpass_lines =
					File.exist?(PGPASS_FILE) ? File.read(PGPASS_FILE).split($RS) : []

				return if pgpass_lines&.include? pgpass_line

				File.write PGPASS_FILE, pgpass_lines.push(pgpass_line, nil).join($RS)
				File.chmod(0o600, PGPASS_FILE)
			end

			# db_connection.loggers << Logger.new($stdout)
		end
	end
end
