# frozen_string_literal: true

require 'commander'
require 'resumer/export'

module Resumer
  module Command
    # Export a YAML CV to an HTML or PDF file
    class Export
      def initialize(args = [], options = nil)
        raise Error, 'No source file given, please provide a YAML source file' \
          unless args.count.positive?

        @export = Resumer::Export.new
        @settings = parse_options(options)
        @src, @dest = parse_args(args)
        @settings[:format] = define_format(@dest) if options.format.nil?
        @settings[:override] = (ask_override if File.exist? @dest) || false
      end

      def parse_args(args)
        source = define_source(args.first)
        destination = define_destination(args[1], source)
        [source, destination]
      end

      def parse_options(options)
        settings = config = {}
        unless options.format.nil?
          settings[:format] = options.format.downcase.to_sym
        end

        config = parse_custom_config(options.config) unless options.config.nil?

        @export.defaults.merge(config, settings)
      end

      def parse_custom_config(config_file)
        config_file_path = File.expand_path(config_file)
        config = load(config_file_path)
        return config if config[:theme].nil?

        config[:theme] = parse_custom_theme(config[:theme], config_file_path)
        config
      end

      def parse_custom_theme(path, base_path)
        theme_path = File.expand_path(path, File.dirname(base_path))
        return theme_path if File.exist?(theme_path)

        raise ArgumentError, "Cannot find custom theme '#{theme_path}'"
      end

      def define_source(arg)
        source = File.absolute_path arg
        raise Error, "Source file does not exist: #{source}" \
          unless File.exist? source

        source
      end

      def define_destination(arg, source)
        return File.absolute_path arg if arg

        # Default to source path with export format extension
        File.join(
          File.absolute_path(File.dirname(source)),
          File.basename(source, '.*')
        ) + '.' + @settings[:format].to_s
      end

      def define_format(destination)
        # File extension without leading dot
        File.extname(destination)[/^\.(.*)/, 1].to_sym
      end

      def ask_override
        agree('Destination exists, do you want to override? [y/N]', true) do |q|
          q.responses[:not_valid] = 'Please enter "[y]es" or "[n]o".'
        end
      end

      def load(file)
        YAML.safe_load(File.read(file), [Symbol], symbolize_names: true)
      rescue StandardError => e
        raise Error, "Failed to read #{file}: #{e.message}"
      end

      # TODO: check the override+file-exists options and throw errors if
      # false+true
      def run
        # Ensure source file is valid YAML/CV
        data = load(@src)

        # Ensure destination format is supported
        unless @export.formats.include? @settings[:format]
          raise Error, "Unsupported format: '#{@settings[:format].to_s.upcase}'"
        end

        say(
          "Exporting #{@src} to #{@dest} in #{@settings[:format].to_s.upcase}" \
          " format (override: #{@settings[:override]})"
        )

        @export.run(data, @dest, @settings)
      end
    end
  end
end
