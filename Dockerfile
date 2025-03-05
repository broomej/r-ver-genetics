FROM rocker/verse:4.4.2

ENV PLINK_VERSION=20241022
ENV PLINK_ZIP=plink_linux_x86_64_${PLINK_VERSION}.zip
ENV PLINK_HOME=/usr/local/plink
ENV PATH=${PLINK_HOME}:${PATH}
ENV VCFTOOLS_VERSION=0.1.16
ENV PATH=/app/vcftools-${VCFTOOLS_VERSION}/bin:${PATH}
# This will clobber the PERL5LIB environment variable if it exists, but fails
# to build if it references an undefined variable
ENV PERL5LIB=/app/vcftools-${VCFTOOLS_VERSION}/share/perl

    # install GENESIS R package
RUN /usr/local/lib/R/site-library/littler/examples/installBioc.r --error GENESIS && \
    `# install GGally R package` \
    install2.r GGally \
    `# install PLINK` \
    wget https://s3.amazonaws.com/plink1-assets/$PLINK_ZIP && \
    unzip $PLINK_ZIP -d $PLINK_HOME && \
    rm $PLINK_ZIP && \
    `# install vcftools` \
    wget https://github.com/vcftools/vcftools/releases/download/v$VCFTOOLS_VERSION/vcftools-$VCFTOOLS_VERSION.tar.gz && \
    tar zxvf vcftools-$VCFTOOLS_VERSION.tar.gz && \
    rm vcftools-$VCFTOOLS_VERSION.tar.gz && \
    cd vcftools-$VCFTOOLS_VERSION && \
    ./configure -prefix=/app/vcftools-$VCFTOOLS_VERSION && \
    make && \
    make install && \
    cd ../ && \
    rm -r vcftools-$VCFTOOLS_VERSION

