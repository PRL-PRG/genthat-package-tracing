# genthat-package-tracing

Running genthat on CRAN packages

## Usage

### Generate packages files

```sh
Rscript -e "writeLines(installed.packages()[,1], 'packages-all.txt')"
Rscript -e "writeLines(sample(installed.packages()[,1], 10), 'packages-10.txt')"
```

### Tracing

```sh
make all PACKAGE_FILE=packages-10.txt
```
