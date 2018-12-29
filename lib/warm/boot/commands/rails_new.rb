# frozen_string_literal: true

module Warm
  module Boot
    module Commands
      class RailsNew
        attr_accessor :cmd, :sh, :opts
        def initialize(opts)
          @opts = opts
          @cmd = ["rails new #{opts.app_name} --quiet"]
          @sh = TTY::Command.new
        end

        def string_builder
          api
          database
          coffeescript
          webpacker
        end

        def execute
          string_builder
          spinner = TTY::Spinner.new("[:spinner] warm-boot ...", format: :dots_4)
          spinner.auto_spin
          check_rails
          sh.run(cmd.join)
          spinner.stop("Done!")
        end

        private

        def check_rails
          return unless rails_gem_installed? == false

          sh.run("gem install rails")
        end

        def rails_gem_installed?
          `gem list -i "^rails$"`.strip
        end

        def database
          cmd << " --database=#{opts.database}"
        end

        def api
          cmd << " --api" if opts.api_only
        end

        def coffeescript
          cmd << " --skip-coffee" unless opts.coffeescript
        end

        def webpacker
          cmd << " --webpack#{framework}" if opts.webpacker
        end

        def framework
          opts.framework == "none" ? "" : "=#{opts.framework}"
        end
      end
    end
  end
end
