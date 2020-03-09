# frozen_string_literal: true

require 'commander'
require 'resumer/export'

module Resumer
  module Command
    # Export a YAML CV to an HTML or PDF file
    class Export < Commander::Command
      def initialize
        super(:export)
        @summary = 'Export a YAML resume to HTML or PDF format'
        @syntax = "#{Resumer::BIN} export <yourCV.yml> [destFilePath.html|.pdf]"
        # TODO: inject custom configuration
        @export = Resumer::Export.new
      end

      def define_source(arg)
        source = File.absolute_path arg
        raise Error, "Source file does not exist: #{source}" \
          unless File.exist? source

        source
      end

      def define_destination(arg, source)
        return File.absolute_path arg if arg

        # Use default format from config or CLI option
        # TODO: check also --format option
        "#{File.absolute_path(File.basename(source, '.*'))}" \
        ".#{@export.default_format}"
      end

      def ask_override
        agree('Destination exists, do you want to override? [y/N]', true) do |q|
          q.responses[:not_valid] = 'Please enter "[y]es" or "[n]o".'
        end
      end

      # TODO: check also --format option
      def define_format(destination)
        # File extension without leading dot
        File.extname(destination)[/^\.(.*)/, 1].to_sym
      end

      def prepare_args(*args)
        source = define_source(args.first)
        destination = define_destination(args[1], source)
        format = define_format(destination)
        [source, destination, format]
      end

      def run(*args)
        raise Error, 'No source file given, please provide a YAML source file' \
          unless args.count.positive?

        source, destination, format = prepare_args(*args)
        override = (ask_override if File.exist? destination) || false
        @export.run(source, destination, format, override)
      rescue StandardError => e
        say "Error (#{e.class.name}): #{e.message}"
        exit 1
      end
    end
  end
end
