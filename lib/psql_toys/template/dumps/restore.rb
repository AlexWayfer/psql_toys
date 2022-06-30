# frozen_string_literal: true

module PSQLToys
	class Template
		class Dumps
			## Define toys for PSQL dumps restoring
			class Restore < Base
				on_expand do |template|
					tool :restore do
						include :exec, exit_on_nonzero_status: true, log_level: Logger::UNKNOWN

						desc 'Restore DB dump'

						optional_arg :step, accept: Integer, default: -1

						to_run do
							@template = template

							@template.update_pgpass

							@dump_file = dump_file_class(@template.db_config).all[step]

							abort 'Dump file not found' unless @dump_file

							@template.confirm "Restore #{@dump_file} ? "

							drop_if_exists

							exec_tool 'db:create'

							restore
						end

						private

						def drop_if_exists
							return unless sh(
								"psql #{@template.db_access} -l | grep '^\s#{@template.db_config[:database]}\s'"
							)

							exec_tool 'db:dump'
							exec_tool 'db:drop'
						end

						def restore
							case @dump_file.format
							when 'custom'
								pg_restore
							when 'plain'
								sh "psql #{@template.db_access} " \
									"#{@template.db_config[:database]} < #{@dump_file.path}"
							else
								raise 'Unknown DB dump file format'
							end
						end

						def pg_restore
							sh "pg_restore #{@template.db_access} -n public " \
								"-d #{@template.db_config[:database]} #{@dump_file.path} " \
								'--jobs=4 --clean --if-exists'
						end
					end
				end
			end
		end
	end
end
