# frozen_string_literal: true

module PSQLToys
	class Template
		class Dumps
			## Define toys for PSQL dumps restoring
			class Restore < Base
				on_expand do |template|
					tool :restore do
						desc 'Restore DB dump'

						optional_arg :step, accept: Integer, default: -1

						to_run do
							@template = template

							@template.update_pgpass

							@dump_file = dump_file_class(@template.db_config).all[step]

							abort 'Dump file not found' unless @dump_file

							ask_question

							drop_if_exists

							exec_tool 'db:create'

							restore
						end

						private

						def ask_question
							require 'highline'
							highline = HighLine.new

							highline.choose do |menu|
								menu.layout = :one_line

								menu.prompt = "Restore #{@dump_file} ? "

								menu.choice(:yes) { nil }
								menu.choice(:no) { abort 'OK' }
							end
						end

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
								## https://github.com/rubocop-hq/rubocop/issues/7884
								# rubocop:disable Layout/IndentationStyle
								sh "psql #{@template.db_access}" \
								   " #{@template.db_config[:database]} < #{@dump_file.path}"
								# rubocop:enable Layout/IndentationStyle
							else
								raise 'Unknown DB dump file format'
							end
						end

						def pg_restore
							## https://github.com/rubocop-hq/rubocop/issues/7884
							# rubocop:disable Layout/IndentationStyle
							sh "pg_restore #{@template.db_access} -n public" \
							   " -d #{@template.db_config[:database]} #{@dump_file.path}" \
							   ' --jobs=4 --clean --if-exists'
							# rubocop:enable Layout/IndentationStyle
						end
					end
				end
			end
		end
	end
end
