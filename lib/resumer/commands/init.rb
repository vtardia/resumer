# frozen_string_literal: true

require 'commander'

module Resumer
  module Command
    # Initialize a resume YAML file
    class Init < Commander::Command
      def initialize
        super(:init)
        @summary = 'Initialize a resume.yml file (not implemented)'
        @syntax = "#{Resumer::BIN} init [/path/to/resume.yml]"
      end

      def run(*_args)
        say "[#{self.class.name}] Feature not yet implemented"
      end
    end
  end
end
