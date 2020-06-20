# frozen_string_literal: true

module PSQLToys
	class Template
		class Dumps
			## Base class for dumps templates
			class Base < Template::Base
				DB_DUMP_FORMATS = %w[custom plain].freeze

				## Common code for dumps toys
				module CommonPSQLDumpsCode
					def db_dumps_dir
						"#{context_directory}/db/dumps"
					end

					def dump_file_class(db_config)
						return @dump_file_class if defined? @dump_file_class

						require_relative '_dump_file'

						db_dumps_dir = self.db_dumps_dir

						@dump_file_class = Class.new(DumpFile) do
							self.db_dumps_dir = db_dumps_dir
							self.db_config = db_config
						end
					end
				end
			end
		end
	end
end
