#!/bin/sh

docker run --rm -v $(pwd)/traces:/traces genthat ./tools/process-traces.R "$@"
