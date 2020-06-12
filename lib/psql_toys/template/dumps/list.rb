# frozen_string_literal: true

module PSQLToys
	class Template
		class Dumps
			## Define toys for PSQL dumps listing
			class List
				include Toys::Template

				on_expand do
					tool :list do
						desc 'List DB dumps'

						def run
							DumpFile.all.each(&:print)
						end
					end
				end
			end
		end
	end
end
