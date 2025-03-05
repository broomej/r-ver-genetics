FROM rocker/verse:4.4.2

    # install GENESIS R package
RUN /usr/local/lib/R/site-library/littler/examples/installBioc.r --error GENESIS && \
    `# install GGally R package` \
    install.r GGally 
