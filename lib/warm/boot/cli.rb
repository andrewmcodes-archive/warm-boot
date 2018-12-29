# frozen_string_literal: true

require "thor"
require "tty"
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
        puts "v#{Warm::Boot::VERSION}"
      end
      map %w(--version -v) => :version

      desc "new", "new rails app"
      def new
        require_relative "commands/rails_new"
        opts = {}
        prompt = TTY::Prompt.new

        opts[:app_name] = prompt.ask("What is the name of the app?", default: "myapp")
        opts[:api_only] = prompt.yes?("Is this an API only app?")
        opts[:database] = prompt.select("Choose your database:", %w(mysql postgresql sqlite3))
        opts[:coffeescript] = prompt.yes?("Do you want to install coffeescript?")
        opts[:webpacker] = prompt.yes?("Do you want to install webpacker?")
        if opts[:webpacker]
          opts[:framework] = prompt.select("Choose your front-end framework:", %w(react vue angular elm stimulus none))
        end
        Warm::Boot::Commands::RailsNew.new(opts).execute if prompt.yes?("Ready to roll?")
      end
      map %w(--new -n) => :new
    end
  end
end
