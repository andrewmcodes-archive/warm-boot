# frozen_string_literal: true

require "thor"
require "tty"
require "warm/boot"
require "fileutils"
module Warm
  module Boot
    # Handle the application command line parsing
    # and the dispatch to various command objects
    #
    # @api public
    class CLI < Thor
      # Error raised by this runner
      Error = Class.new(StandardError)

      desc "version", "warm-boot version"
      def version
        require_relative "version"
        p "v#{Warm::Boot::VERSION}"
      end
      map %w(--version -v) => :version

      # TODO: Need to refactor this and extra rails new commands from gem additions
      desc "new", "new rails app"
      def new # rubocop:disable Metrics/AbcSize
        require_relative "commands/rails_new"
        require_relative "rails_opts"
        prompt = TTY::Prompt.new
        rails_opts = RailsOpts.new(
          app_name: prompt.ask("What is the name of the app?", default: "myapp"),
          api_only: prompt.yes?("Is this an API only app?"),
          database: prompt.select("Choose your database:", %w(mysql postgresql sqlite3)),
          coffeescript: prompt.yes?("Do you want to install coffeescript?"),
          webpacker: prompt.yes?("Do you want to install webpack"),
          framework: "none",
        )
        # JS framework
        if rails_opts.options.webpacker
          rails_opts.options.framework = prompt.select(
            "Choose your front-end framework:", %w(react vue angular elm stimulus none)
          )
        end
        # Generate new rails app
        Warm::Boot::Commands::RailsNew.new(rails_opts.options).execute
        # Cd into new app dir to add gems
        Dir.chdir rails_opts.options.app_name
        # Add annotate gem - for POC
        `bundle add annotate --group="development"` if prompt.yes?("Would you like to install the annotate gem?")
        # Template Lang
        template_lang = prompt.select("Choose your database:", %w(erb haml slim))
        if template_lang == "haml"
          `bundle add haml-rails`
          `bundle exec rails generate haml:application_layout convert`
          `bundle exec rails generate haml:mailer convert`
          FileUtils.rm Dir.glob("app/views/layouts/*.erb")
          FileUtils.rm_rf "app/views/convert"
        elsif template_lang == "slim"
          `bundle add slim-rails`
          `bundle add html2slim --group="development"`
          `erb2slim -d app/views/*`
        end
      end
      map %w(--new -n) => :new
    end
  end
end
