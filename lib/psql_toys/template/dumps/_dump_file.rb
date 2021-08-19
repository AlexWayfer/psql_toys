# frozen_string_literal: true

require 'paint'

## Class for single DB dump file
class DumpFile
	DB_DUMP_TIMESTAMP = '%Y-%m-%d_%H-%M'

	DB_DUMP_TIMESTAMP_REGEXP_MAP = {
		'Y' => '\d{4}',
		'm' => '\d{2}',
		'd' => '\d{2}',
		'H' => '\d{2}',
		'M' => '\d{2}'
	}.freeze

	missing_keys =
		DB_DUMP_TIMESTAMP.scan(/%(\w)/).flatten -
		DB_DUMP_TIMESTAMP_REGEXP_MAP.keys

	if missing_keys.any?
		raise <<~TEXT
			`DB_DUMP_TIMESTAMP_REGEXP_MAP` doesn't contain keys #{missing_keys} for `DB_DUMP_TIMESTAMP`
		TEXT
	end

	DB_DUMP_TIMESTAMP_REGEXP =
		DB_DUMP_TIMESTAMP_REGEXP_MAP
			.each_with_object(DB_DUMP_TIMESTAMP.dup) do |(key, value), result|
				result.gsub! "%#{key}", value
			end

	DB_DUMP_EXTENSIONS = {
		'plain' => '.sql',
		'custom' => '.dump'
	}.freeze

	missing_formats = PSQLToys::Template::Dumps::Base::DB_DUMP_FORMATS.reject do |db_dump_format|
		DB_DUMP_EXTENSIONS[db_dump_format]
	end

	if missing_formats.any?
		raise <<~TEXT
			`DB_DUMP_EXTENSIONS` has no keys for #{missing_formats} from `DB_DUMP_FORMATS`
		TEXT
	end

	class << self
		attr_accessor :db_dumps_dir, :db_config

		def db_dump_regexp
			return unless db_config
			return @db_dump_regexp if defined?(@db_dump_regexp)

			regexp_escaped_db_dump_extensions =
				DB_DUMP_EXTENSIONS.values.map do |db_dump_extension|
					Regexp.escape(db_dump_extension)
				end

			@db_dump_regexp = /^
				#{db_dumps_dir}#{Regexp.escape(File::SEPARATOR)}
				#{db_config[:database]}_#{DB_DUMP_TIMESTAMP_REGEXP}
				(#{regexp_escaped_db_dump_extensions.join('|')})
			$/xo
		end

		def all
			Dir[File.join(db_dumps_dir, '*')]
				.select { |file| file.match?(db_dump_regexp) }
				.map! { |file| new filename: file }
				.sort!
		end
	end

	attr_reader :version, :timestamp, :format

	def initialize(filename: nil, format: 'custom')
		if filename
			@extension = File.extname(filename)
			@format = DB_DUMP_EXTENSIONS.key(@extension)
			self.version = filename[/#{DB_DUMP_TIMESTAMP_REGEXP}/o]
		else
			@format = format
			@extension = DB_DUMP_EXTENSIONS[@format]
			self.timestamp = Time.now
		end
	end

	def <=>(other)
		timestamp <=> other.timestamp
	end

	def to_s
		"#{readable_timestamp} #{format}"
	end

	def print
		puts to_s
	end

	def path
		File.join self.class.db_dumps_dir, "#{self.class.db_config[:database]}_#{version}#{@extension}"
	end

	private

	def version=(value)
		@version = value
		@timestamp = Time.strptime(version, DB_DUMP_TIMESTAMP)
	end

	def timestamp=(value)
		@timestamp = value
		@version = timestamp.strftime(DB_DUMP_TIMESTAMP)
	end

	def readable_timestamp
		Paint[timestamp.strftime('%F %R'), :cyan]
	end
end
