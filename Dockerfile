FROM rocker/verse:4.5.1

USER root

ENV PLINK_VERSION=latest
ENV PLINK_ZIP=plink_linux_x86_64_${PLINK_VERSION}.zip
ENV PLINK_HOME=/usr/local/plink
ENV PATH=${PLINK_HOME}:${PATH}
# There are some littler utilities not automatically added to path
ENV PATH=/usr/local/lib/R/site-library/littler/examples/:${PATH}

RUN \
    `# navigate to temp directory for setup` \
     mkdir setuptemp && cd setuptemp && \
    `# update packages` \
    apt-get update && apt-get upgrade -y && \
    `# install gnu parallel and jq ` \
    apt-get install -y parallel jq && \
    `# install miniforge ` \
    wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" && \
    bash Miniforge3-$(uname)-$(uname -m).sh -b && \
    `# install snakemake ` \
    conda create -c conda-forge -c bioconda -c nodefaults -n snakemake snakemake && \
    `# install PLINK` \
    wget https://s3.amazonaws.com/plink1-assets/$PLINK_ZIP && \
    unzip $PLINK_ZIP -d $PLINK_HOME && \
    rm $PLINK_ZIP && \
    `# install vcftools` \
    export VCFTOOLS_VERSION=$(curl https://api.github.com/repos/vcftools/vcftools/releases/latest -s | jq .name -r | sed -e "s/^v//") && \
    export PATH=/app/vcftools-$VCFTOOLS_VERSION/bin:$PATH && \
    `# This will clobber the PERL5LIB environment variable if it exists, but fails` \
    `# to build if it references an undefined variable` \
    export PERL5LIB=/app/vcftools-$VCFTOOLS_VERSION/share/perl && \
    wget https://github.com/vcftools/vcftools/releases/download/v$VCFTOOLS_VERSION/vcftools-$VCFTOOLS_VERSION.tar.gz && \
    tar zxvf vcftools-$VCFTOOLS_VERSION.tar.gz && \
    rm vcftools-$VCFTOOLS_VERSION.tar.gz && \
    cd vcftools-$VCFTOOLS_VERSION && \
    ./configure -prefix=/app/vcftools-$VCFTOOLS_VERSION && \
    make && \
    make install && \
    cd ../ && \
    rm -r vcftools-$VCFTOOLS_VERSION && \
    `# Install bcftools and dependencies` \
    export SAMTOOLS_VERSION=$(curl https://api.github.com/repos/samtools/bcftools/releases/latest -s | jq .name -r) && \
    git clone --depth 1 --recurse-submodules --branch $SAMTOOLS_VERSION https://github.com/samtools/htslib.git && \
    cd htslib && \
    autoreconf -i && ./configure && \
    make && \
    make install && \
    cd ../ && \
    git clone --depth 1 --recurse-submodules --branch $SAMTOOLS_VERSION https://github.com/samtools/bcftools.git && \
    cd bcftools && \
    autoheader && autoconf && ./configure && \
    make && \
    make install && \
    `# install GGally R package` \
    install2.r GGally && \
    # `install GENESIS R package` \
    installBioc.r --error GENESIS && \
    # `clean up setup directory` \
    cd ../ && rm -rf setuptemp

