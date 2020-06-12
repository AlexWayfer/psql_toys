# frozen_string_literal: true

module PSQLToys
	class Template
		class Dumps
			## Define toys for PSQL dumps creation
			class Create < Base
				on_expand do
					tool :create do
						desc 'Make DB dump'

						flag :format, '-f', '--format=VALUE',
							default: DB_DUMP_FORMATS.first,
							handler: (lambda do |value, _previous|
								DB_DUMP_FORMATS.find do |db_dump_format|
									db_dump_format.start_with? value
								end
							end)

						def run
							require 'benchmark'

							update_pgpass

							sh "mkdir -p #{DB_DUMPS_DIR}"
							time = Benchmark.realtime do
								## https://github.com/rubocop-hq/rubocop/issues/7884
								# rubocop:disable Layout/IndentationStyle
								sh "pg_dump #{db_access} -F#{format.chr}" \
								   " #{db_config[:database]} > #{filename}"
								# rubocop:enable Layout/IndentationStyle
							end
							puts "Done in #{time.round(2)} s."
						end

						private

						def filename
							DumpFile.new(format: format).path
						end
					end
				end
			end
		end
	end
end
