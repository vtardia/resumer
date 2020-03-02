# frozen_string_literal: true

require 'resumer/version'

module Resumer
  class Error < StandardError; end

  # Dummy test class
  class Dummy
    def self.hi
      'Hello from Resumer, cool features coming!'
    end
  end
end
