#!/bin/sh

set -e

dir=`dirname $0`
cmd=${1:-"screen -xRR"}
pidfile="$dir/shellinaboxd.pid"

# This assumes that screen is installed, and that the invoking user
# is a member of a group whose name is identical to the username.
shellinaboxd \
	--background=$pidfile \
	--localhost-only \
	--no-beep \
	--disable-ssl \
	--css=$dir/../css/shellinabox.css \
	--service /:$USER:$USER:HOME:"$cmd"

echo "shellinaboxd started in background. Shutdown with \"kill -TERM `cat $pidfile`\"." >&2
