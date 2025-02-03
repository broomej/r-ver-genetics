FROM rocker/verse:4.4.2

RUN /usr/local/lib/R/site-library/littler/examples/installBioc.r --error GENESIS

