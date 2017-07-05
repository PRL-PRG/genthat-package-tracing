# genthat-package-tracing

Running genthat on CRAN packages

## Usage

### Tracing

Make sure the DB is up and running using `./start-mysql.sh`

```sh
$ mkdir runs/cran-top-100
$ cd runs/cran-top-100
$ ../../cran-top-n.R 100 > packages.txt
$ parallel --bar --results jobs --joblog jobs.log -j4 -a packages.txt --timeout 3600 ../../trace-package.sh ::: examples tests vignettes
```
