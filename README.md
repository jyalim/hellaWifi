hellaWifi
=========

A simple bash daemon (background process) to keep a WiFi session alive
on Apple's OS X 10 Yosemite (10.10.0). 

Pings the router associated with the network, and will adjust adequately
  to a new WiFi network.

This is a terminal application. It must be started within the shell.

The shell that is default with Yosemite is called Terminal.app, and a 
  spotlight search for "Terminal" will find it. 

The daemon script is handled with Mac OS X's launchd job handler.

To install and run it:

    $ bash install-start-on-boot.bash

where the dollar sign only implies the use of the Bash shell and is 
  non-literal (don't include it if trying to run the program).
The installer creates a plist file that tells launchd where to find
  hellaWifi.bash.
It is not recommended to remove any files post installation as the 
  current setup expects hellaWifi.bash to be in the git directory.

To stop the process and remove the daemon from starting on login:

    $ bash remove-start-on-boot.bash

The installer and uninstaller scripts will not need root as the user 
  will own the process.
The daemon will be installed to $HOME/Library/LaunchAgents/ via the 
  plist org.hellabyte.hellawifi.plist.

Motivation
==========

Especially when using bluetooth on a network, the WiFi network will drop
  every few minutes in Yosemite 10.10.0. 
This annoying feature of the latest operating system from Apple can be 
  overcome by simply pinging the router of the host network.
Since WiFi is generally used with laptops, a daemon nicely automates the
  process of killing a previous ping associated with an older WiFi 
  network and starting a new ping on a current network.

Style
=====

It will run in the background simply pinging a router keeping a WiFi
  session alive.
When the daemon starts, a log file, $HOME/.local/var/log/hellaWifi.log
  will be created or appended to.
This log file will note the IP of the routers being connected to and 
  the process id of the active ping.
Further, $HOME/.local/tmp/hellawifi-ppid will contain the active ping 
  pid. 
This temporary file will be deleted when the process shuts down, but is
  necessary to correctly shut down the process.


(c) 2014 - 11 - 07 Nathaniel Hellabyte 
