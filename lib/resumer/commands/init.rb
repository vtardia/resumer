# frozen_string_literal: true

require 'commander'

module Resumer
  module Command
    # Initialize a resume YAML file
    class Init < Commander::Command
      def initialize
        super(:init)
        @summary = 'Initialize a resume.yml file'
        @syntax = "#{Resumer::BIN} init [/path/to/resume.yml]"
        @template = File.expand_path(
          "#{File.dirname(__FILE__)}/../../../templates/default.yml"
        )
      end

      def ask_override
        agree('Destination exists, do you want to override? [y/n]', true) do |q|
          q.responses[:not_valid] = 'Please enter "[y]es" or "[n]o".'
        end
      end

      def parse_dest(path)
        return File.join(Dir.pwd, 'resume.yml') if path.nil?

        dest = File.expand_path(path)
        return File.join(dest, 'resume.yml') if File.directory? dest

        dest
      end

      def run(*args)
        dest = parse_dest(args.first)
        override = (ask_override if File.exist? dest) || false
        return if File.exist?(dest) && !override

        FileUtils.cp @template, dest
        say "Your new resume is ready at '#{dest}'"
        say 'Good luck!'
      rescue Errno => e
        say e.message
        exit e.class::Errno
      end
    end
  end
end
