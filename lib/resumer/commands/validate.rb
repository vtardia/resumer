# frozen_string_literal: true

require 'commander'

module Resumer
  module Command
    # Validate a YAML resume
    class Validate < Commander::Command
      def initialize
        super(:validate)
        @summary = 'Validate your YAML resume (not implemented)'
        @syntax = "#{Resumer::BIN} validate [/path/to/resume.yml]"
      end

      def run(*_args)
        say "[#{self.class.name}] Feature not yet implemented"
      end
    end
  end
end
