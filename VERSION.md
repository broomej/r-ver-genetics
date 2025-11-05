# Image and package versions

## Image version: 4.5.2.0

This image uses the [major].[minor].[patch] version of R from the base image,
and appends another digit for versions of the image itself. The first version
following an update to the base version will have zero as the final digit e.g.
when the base image 4.4.2 was released, the corresponding version of this image
is 4.4.2.0. I maintain corresponding two- and three-digit version numbers e.g.
when v4.4.2.1 was released, it was also tagged with 4.4.2 and 4.4. Use the tag
`stable` for the most up-to-date version of this image as `latest` is often
experimental or built on an older version of the base image.

## Snakemake version: 9.13.5

Snakemake is currently the only package in this image that I need to track every
version specifically. Snakemake's Apptainer interface requires the same version
of Snakemake to be installed on the host and the image, so for added
flexibility, I'm rebuilding and publishing the image with each Snakemake update
and tag accordingly.