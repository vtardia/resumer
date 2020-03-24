# frozen_string_literal: true

require 'yaml'
require 'ostruct'
require 'pdfkit'
require 'kramdown'

module Resumer
  # Export a YAML CV to an HTML or PDF file
  class Export
    attr_reader :defaults
    attr_reader :formats

    def initialize
      @formats = %i[html pdf]
      @defaults = {
        format: @formats.first,
        theme: File.expand_path(
          "#{File.dirname(__FILE__)}/../../themes/default"
        ),
        pdf: pdf_defaults
      }
    end

    def pdf_defaults
      {
        page_size: 'A4',
        margin_top: '1.5cm',
        margin_bottom: '1.4cm',
        margin_left: '1.5cm',
        margin_right: '1.5cm',
        print_media_type: true
      }
    end

    def default_format
      @defaults[:format]
    end

    # Transform the YAML object in an OpenStruct with symbol keys
    def normalize(data)
      return normalize_hash(data) if data.is_a? Hash

      return normalize_array(data) if data.is_a? Array

      data
    end

    def normalize_hash(data)
      result = OpenStruct.new data
      data.each do |k, v|
        result[k] = normalize(v)
      end
      result
    end

    def normalize_array(data)
      result = []
      data.each do |i|
        result.push normalize(i)
      end
      result
    end

    # Markdown helper for tempaltes
    def markdown(text)
      Kramdown::Document.new(text).to_html
    end

    def create_html(data, theme = @defaults[:theme], with_style = false)
      # Load the theme
      erb = ERB.new(
        File.read(File.absolute_path("#{theme}/index.html"))
      )
      if with_style
        style = File.read(
          File.absolute_path("#{theme}/css/styles.css")
        )
      end
      data = normalize(data)
      # Generate the HTML
      erb.result(binding)
    end

    def save_html(html, dest)
      File.open(dest, 'w+') do |file|
        file.puts html
      end
    end

    def save_pdf(html, dest, theme = @defaults[:theme])
      pdf_config
      kit = PDFKit.new(html)

      # Load generic styles
      kit.stylesheets << "#{theme}/css/styles.css"

      # Load PDF-specific styles
      pdfstyles = "#{theme}/css/pdf.styles.css"
      kit.stylesheets << pdfstyles if File.exist? pdfstyles

      # Compile and save
      kit.to_file(dest)
    end

    def run(data, dest, settings = @defaults)
      raise Error, 'Invalid or empty source data' if data.nil?

      html = create_html(data, settings[:theme], (settings[:format] == :html))
      case settings[:format]
      # Process HTML export
      when :html
        save_html(html, dest)
      # Process PDF export
      when :pdf
        save_pdf(html, dest, settings[:theme])
      else
        raise Error, "Invalid format #{settings[:format].to_s.upcase}"
      end
    end

    private

    def pdf_config
      PDFKit.configure do |config|
        # config.wkhtmltopdf = '/path/to/wkhtmltopdf'
        config.default_options = pdf_defaults
        # Use only if your external hostname is unavailable on the server.
        # config.root_url = "file://#{File.dirname('../')}/themes/default"
        # config.protocol = 'file'
        config.verbose = false
      end
    end
  end
end
