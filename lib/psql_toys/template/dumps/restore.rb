# frozen_string_literal: true

module PSQLToys
	class Template
		class Dumps
			## Define toys for PSQL dumps restoring
			class Restore < Base
				on_expand do
					tool :restore do
						desc 'Restore DB dump'

						optional_arg :step, accept: Integer, default: -1

						def run
							update_pgpass

							@dump_file = DumpFile.all[step]

							abort 'Dump file not found' unless @dump_file

							ask_question

							drop_if_exists

							exec_tool 'db:create'

							restore
						end

						private

						def ask_question
							require 'highline'
							highline = Highline.new

							highline.choose do |menu|
								menu.layout = :one_line

								menu.prompt = "Restore #{@dump_file} ? "

								menu.choice(:yes) {}
								menu.choice(:no) { abort 'OK' }
							end
						end

						def drop_if_exists
							return unless sh(
								"psql #{db_access} -l | grep '^\s#{db_config[:database]}\s'"
							)

							exec_tool 'db:dump'
							exec_tool 'db:drop'
						end

						def restore
							case @dump_file.format
							when 'custom'
								pg_restore
							when 'plain'
								## https://github.com/rubocop-hq/rubocop/issues/7884
								# rubocop:disable Layout/IndentationStyle
								sh "psql #{db_access}" \
								   " #{db_config[:database]} < #{@dump_file.path}"
								# rubocop:enable Layout/IndentationStyle
							else
								raise 'Unknown DB dump file format'
							end
						end

						def pg_restore
							## https://github.com/rubocop-hq/rubocop/issues/7884
							# rubocop:disable Layout/IndentationStyle
							sh "pg_restore #{db_access} -n public" \
							   " -d #{db_config[:database]} #{@dump_file.path}" \
							   ' --jobs=4 --clean --if-exists'
							# rubocop:enable Layout/IndentationStyle
						end
					end
				end
			end
		end
	end
end
