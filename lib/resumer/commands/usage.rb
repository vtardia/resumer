# frozen_string_literal: true

require 'commander'

module Resumer
  module Command
    # Display usage info
    class Usage < Commander::Command
      def initialize
        super(:usage)
        @summary = 'Display usage info'
        @syntax = "#{Resumer::BIN} <command> [options] <args>"
      end

      def run(*_args)
        say("usage: #{@syntax}")
      end
    end
  end
end
