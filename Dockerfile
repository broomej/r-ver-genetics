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
    `# install miniforge ` \
    wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" && \
    bash Miniforge3-$(uname)-$(uname -m).sh -b && \
    /root/miniforge3/bin/conda init bash && \
    `# install snakemake ` \
    /root/miniforge3/bin/conda create -c conda-forge -c bioconda -c nodefaults -n snakemake snakemake && \
    echo "conda activate snakemake" >> /root/.bashrc && \
    # `clean up setup directory` \
    cd ../ && rm -rf setuptemp
