require 'fileutils'
require 'securerandom'

module Lagunitas
  class IPA
    def initialize(path)
      @path = path
    end

    def app
      @app ||= App.new(app_path)
    end

    def app_path
      @app_path ||= Dir.glob(File.join(contents, 'Payload', '*.app')).first
    end

    def size
      File.size(@path)
    end

    def cleanup
      return unless @contents
      FileUtils.rm_rf(@contents)
      @contents = nil
    end

    private

    def contents
      return if @contents
      @contents = File.dirname(@path)

      `unzip -o "#{@path}" -d "#{@contents}"`

      @contents
    end
  end
end
