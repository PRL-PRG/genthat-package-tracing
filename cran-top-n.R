#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=TRUE)
if (length(args) != 1) {
    stop("Usage: <N>")
}

N <- as.numeric(args[1])

writeLines(cranlogs::cran_top_downloads(when="last-month", count=N)[,2])
