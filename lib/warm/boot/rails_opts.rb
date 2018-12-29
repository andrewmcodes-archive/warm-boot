# frozen_string_literal: true

class RailsOpts
  Options = Struct.new(:app_name, :api_only, :database, :coffeescript, :webpacker, :framework)

  attr_accessor :options

  def initialize(opts)
    @options = Options.new(
      opts[:app_name], opts[:api_only], opts[:database], opts[:coffeescript], opts[:webpacker], opts[:framework]
    )
  end
end
