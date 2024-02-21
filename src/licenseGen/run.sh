#!/bin/sh

DIR=`dirname "$0"`
DIR=`exec 2>/dev/null;(cd -- "$DIR") && cd -- "$DIR"|| cd "$DIR"; unset PWD; /usr/bin/pwd || /bin/pwd || pwd`

# Grab the absolute path to the default pfx location
cert_path="$DIR/../../.keys/cert.pfx"

docker run -it --rm -v "$cert_path:/cert.pfx" bitbetter/licensegen "$@"