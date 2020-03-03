# frozen_string_literal: true

require 'commander'

module Resumer
  module Command
    # Export a YAML CV to an HTML or PDF file
    class Export < Commander::Command
      def initialize
        super(:export)
        @summary = 'Export a YAML resume to HTML or PDF format'
        @syntax = "#{Resumer::BIN} export <yourCV.yml> [destFilePath.html|.pdf]"
      end

      def run(*args)
        raise Error, 'No source file given, please provide a YAML source file' \
          unless args.count.positive?

        say 'Exporting...'
      rescue StandardError => e
        say "Error (#{e.class.name}): #{e.message}"
        exit 1
      end
    end
  end
end
