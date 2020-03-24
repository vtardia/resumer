# frozen_string_literal: true

require 'resumer/error'
require 'resumer/info'
require 'commander'

# Require all the available commands
Dir.glob(File.expand_path('resumer/commands/*.rb', __dir__), &method(:require))

module Resumer
  # Commander CLI interface
  class CLI
    include Commander::Methods

    def initialize
      program :name, Resumer::PKG
      program :version, Resumer::VERSION
      program :description, Resumer::DESCRIPTION
      program :help_formatter, :compact
      program :help, *Resumer::AUTHOR
    end

    # rubocop:disable Metrics/MethodLength
    def add_export_command
      command :export do |c|
        c.option '-c', '--config FILE', 'Load a custom configuration file'
        c.option '--format STRING', 'Destination format (HTML or PDF)'
        c.summary = 'Export a YAML resume to HTML or PDF format'
        c.syntax = "#{Resumer::BIN} export <source.yml> [destination.html|.pdf]"
        c.action do |args, options|
          Resumer::Command::Export.new(args, options).run
        rescue StandardError => e
          say "Error (#{e.class.name}): #{e.message}"
          exit 1
        end
      end
    end
    # rubocop:enable Metrics/MethodLength

    def run
      default_command :usage
      add_command(Resumer::Command::Usage.new)
      add_command(Resumer::Command::Init.new)
      add_command(Resumer::Command::Validate.new)
      add_export_command
      run!
    end
  end
end
