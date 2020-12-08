# frozen_string_literal: true

require 'toys-core'

module PSQLToys
	## Define toys for Sequel migrations
	class Template
		include Toys::Template

		attr_reader :db_config_proc, :db_connection_proc, :db_extensions

		def initialize(db_config_proc:, db_connection_proc:, db_extensions: %w[citext pgcrypto])
			@db_config_proc = db_config_proc
			@db_connection_proc = db_connection_proc
			@db_extensions = db_extensions
		end

		on_expand do |template|
			tool :database do
				require_relative 'template/_base'

				require 'gorilla_patch/inflections'
				using GorillaPatch::Inflections

				%w[Create CreateExtensions Drop Console Dumps].each do |template_name|
					require_relative "template/#{template_name.underscore}"
					expand Template.const_get(template_name, false),
						db_config_proc: template.db_config_proc,
						db_connection_proc: template.db_connection_proc,
						db_extensions: template.db_extensions
				end
			end

			alias_tool :psql, 'database:psql'
		end
	end
end
