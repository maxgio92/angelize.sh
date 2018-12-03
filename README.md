# angelize.sh
It's a simple bash script to control daemons like normal foreground processes.

It launches your daemon; forwards SIGINT and SIGTERM signals to the daemonized child processes; exits when children exit.

#### Example use case
##### Supervisord + angelize.sh
You can control daemons with [Supervisord](http://supervisord.org) via angelize.sh.

## Usage

`angelize.sh -p [daemon pidfile path] -c [daemon command]`
