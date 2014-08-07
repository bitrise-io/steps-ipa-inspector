require_relative '../3rdparty/cfpropertylist'

module Lagunitas
  class App
    def initialize(path)
      @path = path
    end

    def info
      @info ||= CFPropertyList.native_types(CFPropertyList::List.new(file: File.join(@path, 'Info.plist')).value)
    end

    def embedded
      @embedded ||= CFPropertyList.native_types(CFPropertyList::List.new(data: `security cms -D -i #{File.join(@path, 'embedded.mobileprovision')}`).value)
    end

    def identifier
      info['CFBundleIdentifier']
    end

    def display_name
      info['CFBundleDisplayName']
    end

    def version
      info['CFBundleVersion']
    end

    def short_version
      info['CFBundleShortVersionString']
    end

    def creation_date
      embedded['CreationDate'].utc
    end

    def expiration_date
      embedded['ExpirationDate'].utc
    end

    def provision_devices
      embedded['ProvisionedDevices']
    end

    def icon(size)
      icons.each do |icon|
        return icon[:path] if icon[:width] >= size
      end
      nil
    end

    def uncrushed_icon(size)
      icons.each do |icon|
        return icon[:uncrushed_path] if icon[:width] >= size
      end
      nil
    end

    def icons
      @icons ||= begin
        icons = []
        info['CFBundleIcons']['CFBundlePrimaryIcon']['CFBundleIconFiles'].each do |name|
          icons << get_image(name)
          icons << get_image("#{name}@2x")
        end
        icons.delete_if { |i| !i }
      end
    end

    private

    def get_image(name)
      path = File.join(@path, "#{name}.png")
      return nil unless File.exist?(path)

      uncrushed_path = File.join(@path, "#{name}_u.png")
      `xcrun -sdk iphoneos pngcrush -revert-iphone-optimizations -q #{path} #{uncrushed_path}`

      {
        path: path,
        uncrushed_path: uncrushed_path,
        width: `sips -g pixelWidth #{path} | tail -n1 | cut -d" " -f4`.to_i,
        height: `sips -g pixelHeight #{path} | tail -n1 | cut -d" " -f4`.to_i
      }
    rescue Errno::ENOENT
      nil
    end
  end
end
