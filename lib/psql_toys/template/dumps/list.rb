# frozen_string_literal: true

module PSQLToys
	class Template
		class Dumps
			## Define toys for PSQL dumps listing
			class List < Base
				include Toys::Template

				on_expand do |template|
					tool :list do
						desc 'List DB dumps'

						to_run do
							dump_file_class(template.db_config).all.each(&:print)
						end
					end
				end
			end
		end
	end
end
