module Warm
  module Boot
    module Commands
      class RailsNew
        attr_accessor :cmd, :opts
        def initialize(opts)
          @opts = opts
          @cmd = "rails new #{opts[:app_name]}"
        end

        def string_builder
          api
          database
          coffeescript
          webpacker
        end

        def execute
          p string_builder
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
