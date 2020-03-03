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

    def run
      default_command :usage
      add_command(Resumer::Command::Usage.new)
      add_command(Resumer::Command::Init.new)
      add_command(Resumer::Command::Validate.new)
      add_command(Resumer::Command::Export.new)
      run!
    end
  end
end
