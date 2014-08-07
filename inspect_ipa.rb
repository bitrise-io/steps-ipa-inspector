require_relative 'lib/lagunitas'

def save_env(key, value)
  puts "$ echo export #{key}=\"#{value}\" >> #{@profile}"
  open(@profile, 'a') { |f|
    f.puts("export #{key}=\"#{value}\"")
  }

  send_formatted_output(key, value)
end

def send_formatted_output(key, value)
  open(@formatted_output, 'a') { |f|
    f.puts("* **#{key}**: #{value}\"")
  }
end

path = ARGV[0] || nil
unless path
  puts "No IPA path found"
  exit 1
end

@profile = File.expand_path(ARGV[1]) || nil
unless @profile
  puts "No profile path specified"
  exit 1
end

@formatted_output = File.expand_path(ARGV[2]) || nil
unless @formatted_output
  puts "No formatted output path specified"
  exit 1
end

@ipa = Lagunitas::IPA.new(path)
@app = @ipa.app

save_env "IPA_SIZE", @ipa.size

save_env "IPA_IDENTIFIER", @app.identifier
save_env "IPA_DISPLAY_NAME", @app.display_name
save_env "IPA_VERSION", @app.version
save_env "IPA_SHORT_VERSION", @app.short_version
save_env "IPA_CREATION_DATE", @app.creation_date.to_i
save_env "IPA_EXPIRATION_DATE", @app.expiration_date.to_i
save_env "IPA_PROVISION_DEVICES", @app.provision_devices.join(", ")

icons = [512, 256, 120, 60, 40]
icons.each do |size|
  icon_path = @app.uncrushed_icon(size)
  if icon_path
    save_env "IPA_ICON", icon_path
    break
  end
end
