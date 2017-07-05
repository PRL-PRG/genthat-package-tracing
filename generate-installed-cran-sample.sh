#!/bin/sh

docker run --rm genthat Rscript -e \
  "pkgs <- installed.packages(); \
   paths <- file.path(pkgs[, 'LibPath'], pkgs[, 'Package']); \
   cat(sample(paths, size=$1, replace=TRUE), sep='\n')"
