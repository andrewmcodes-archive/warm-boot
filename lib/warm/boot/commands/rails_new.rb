# frozen_string_literal: true

module Warm
  module Boot
    module Commands
      class RailsNew
        attr_accessor :cmd, :opts
        def initialize(opts)
          @opts = opts
          @cmd = ["rails new #{opts[:app_name]} -q -f"]
        end

        def string_builder
          api
          database
          coffeescript
          webpacker
        end

        def execute
          string_builder
          my_cmd = TTY::Command.new
          spinner = TTY::Spinner.new("[:spinner] warm-boot ...", format: :dots_4)
          spinner.auto_spin
          my_cmd.run(cmd.join)
          spinner.stop("Done!")
        end

        private

        def database
          cmd << " --database=#{opts[:database]}"
        end

        def api
          cmd << " --api" if opts[:api_only]
        end

        def coffeescript
          cmd << " --skip-coffee" unless opts[:coffeescript]
        end

        def webpacker
          cmd << " --webpack#{framework}" if opts[:webpacker]
        end

        def framework
          opts[:framework] == "none" ? "" : "=#{opts[:framework]}"
        end
      end
    end
  end
end
