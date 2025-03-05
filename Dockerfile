FROM rocker/verse:4.4.2
ENV PLINK_VERSION       20241022
ENV PLINK_ZIP           plink_linux_x86_64_$PLINK_VERSION.zip
ENV PLINK_HOME          /usr/local/plink
ENV PATH                $PLINK_HOME:$PATH

    # install GENESIS R package
RUN /usr/local/lib/R/site-library/littler/examples/installBioc.r --error GENESIS && \
    `# install GGally R package` \
    install2.r GGally \
    `# install PLINK` \
    wget https://s3.amazonaws.com/plink1-assets/$PLINK_ZIP && \
    unzip $PLINK_ZIP -d $PLINK_HOME && \
    rm $PLINK_ZIP

