require 'uglifier'
require 'cssminify2'
require 'htmlcompressor'
require 'json'

module Jekyll
  module MinifyFilter
    def minify(input, type)
      # If input is nil, return an empty string
      return "" if input.nil?
      
      # Remove the front matter
      input = input.sub(/\A---.*?---\s/m, '')

      case type
      when 'js'
        uglifier = Uglifier.new(harmony: true)
        uglifier.compile(input)
      when 'json'
        JSON.generate(JSON.parse(input))
      when 'css'
        CSSminify2.compress(input)
      when 'html'
        compressor = HtmlCompressor::Compressor.new
        compressor.compress(input)
      else
        input
      end
    rescue StandardError => e
      Jekyll.logger.error "Error minifying input: #{e.message}"
      input
    end
  end
end

Liquid::Template.register_filter(Jekyll::MinifyFilter)
