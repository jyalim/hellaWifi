#!/usr/bin/env bash

workin_path="$(pwd -P)"

lagent_name="org.hellabyte.hellawifi"

source_file="hellaWifi.bash"
lagent_file="${lagent_name}.plist"

source_path="${workin_path}/${source_file}"
lagent_path="${workin_path}/${lagent_file}"

target_path="${HOME}/Library/LaunchAgents/${lagent_file}"

cat << __EOF >| $lagent_file
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
      <string>$lagent_name</string>
    <key>ProgramArguments</key>
      <array>
        <string>$source_path</string>
      </array>
    <key>Nice</key>
      <integer>5</integer>
    <key>RunAtLoad</key>
      <true/>
  </dict>
</plist>
__EOF

cp -v $lagent_path $target_path
 
# Unload old plist if loaded
launchctl list | grep $lagent_name &>/dev/null && \
  launchctl unload $target_path || :

# Load new plist
echo "Starting daemon for current session"
launchctl load $target_path
