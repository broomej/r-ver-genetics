FROM rocker/verse:latest

ENV PLINK_VERSION=latest
ENV PLINK_ZIP=plink_linux_x86_64_${PLINK_VERSION}.zip
ENV PLINK_HOME=/usr/local/plink
ENV PATH=${PLINK_HOME}:${PATH}
# There are some littler utilities not automatically added to path
ENV PATH=/usr/local/lib/R/site-library/littler/examples/:${PATH}

# install GGally R package
RUN install2.r GGally && \
    `# install PLINK` \
    wget https://s3.amazonaws.com/plink1-assets/$PLINK_ZIP && \
    unzip $PLINK_ZIP -d $PLINK_HOME && \
    rm $PLINK_ZIP && \
    `# install vcftools` \
    git clone --depth 1 --recurse-submodules --branch latest https://github.com/vcftools/vcftools.git && \
    cd vcftools && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    cd ../ && \
    `# Install bcftools and dependencies` \
    git clone --depth 1 --recurse-submodules --branch latest https://github.com/samtools/htslib.git && \
    cd htslib && \
    autoreconf -i && ./configure && \
    make && \
    make install && \
    cd ../ && \
    git clone --depth 1 --recurse-submodules --branch latest https://github.com/samtools/bcftools.git && \
    cd bcftools && \
    autoheader && autoconf && ./configure && \
    make && \
    make install && \
    # `install GENESIS R package` \
    installBioc.r  --error GENESIS

