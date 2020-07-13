# frozen_string_literal: true

module PSQLToys
	class Template
		## Define toys for database drop
		class Drop < Base
			on_expand do |template|
				tool :drop do
					desc 'Drop DB'

					flag :force, '-f', '--[no-]force'
					flag :question, '-q', '--[no-]question', default: true

					to_run do
						@database = template.db_config[:database]

						ask_question if question

						exec_tool 'db:dump' unless force

						template.db_connection.disconnect
						sh "dropdb --if-exists #{template.db_access} #{@database}"
					end

					private

					def ask_question
						require 'highline'
						highline = HighLine.new

						highline.choose do |menu|
							menu.layout = :one_line

							menu.prompt = "Drop #{@database} ? "

							menu.choice(:yes) {}
							menu.choice(:no) { abort 'OK' }
						end
					end
				end
			end
		end
	end
end
