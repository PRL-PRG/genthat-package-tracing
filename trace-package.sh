#!/bin/sh

docker run --rm -v $(pwd)/traces:/traces genthat ./tools/trace-package.R "$1" "$2" /traces 500
