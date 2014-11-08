#!/usr/bin/env bash

workin_path="$(pwd -P)"

lagent_name="org.hellabyte.hellawifi"
lagent_file="${lagent_name}.plist"

target_path="${HOME}/Library/LaunchAgents/${lagent_file}"

echo "Stopping Daemon"
launchctl list | grep $lagent_name && launchctl unload $target_path || :

echo "Removing Daemon plist"
rm -v $target_path

