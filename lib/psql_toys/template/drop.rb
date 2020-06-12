# frozen_string_literal: true

module PSQLToys
	class Template
		## Define toys for database drop
		class Drop < Base
			on_expand do
				tool :drop do
					desc 'Drop DB'

					flag :force, '-f', '--[no-]force'
					flag :question, '-q', '--[no-]question', default: true

					def run
						ask_question if question

						exec_tool 'db:dump' unless force

						db_connection.disconnect
						sh "dropdb --if-exists #{db_access} #{db_config[:database]}"
					end

					private

					def ask_question
						require 'highline'
						highline = Highline.new

						highline.choose do |menu|
							menu.layout = :one_line

							menu.prompt = "Drop #{db_config[:database]} ? "

							menu.choice(:yes) {}
							menu.choice(:no) { abort 'OK' }
						end
					end
				end
			end
		end
	end
end
