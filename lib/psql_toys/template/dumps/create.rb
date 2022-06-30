# frozen_string_literal: true

module PSQLToys
	class Template
		class Dumps
			## Define toys for PSQL dumps creation
			class Create < Base
				on_expand do |template|
					tool :create do
						include :exec, exit_on_nonzero_status: true, log_level: Logger::UNKNOWN

						desc 'Make DB dump'

						flag :format, '-f', '--format=VALUE',
							default: DB_DUMP_FORMATS.first,
							handler: (lambda do |value, _previous|
								DB_DUMP_FORMATS.find do |db_dump_format|
									db_dump_format.start_with? value
								end
							end)

						to_run do
							require 'benchmark'

							template.update_pgpass

							sh "mkdir -p #{db_dumps_dir}"

							filename = dump_file_class(template.db_config).new(format: format).path

							relative_filename = filename.gsub("#{context_directory}/", '')

							puts "Creating dump #{relative_filename}..."

							time = Benchmark.realtime do
								sh "pg_dump #{template.db_access} -F#{format.chr} " \
									"#{template.db_config[:database]} > #{filename}"
							end

							puts "Done in #{time.round(2)} s."
						end
					end
				end
			end
		end
	end
end
