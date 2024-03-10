ARG POSTGRES_VERSION 16
ARG POSTGIS_VERSION 3.4

# postgis base image
FROM kartoza/postgis:${POSTGRES_VERSION}-${POSTGIS_VERSION}

# Download and extract GEOS
ARG GEOS_VERSION 3.12.1

RUN apt-get update && apt-get install -y build-essential wget \
    && wget http://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2 \
    && tar xjf geos-${GEOS_VERSION}.tar.bz2 \
    && rm geos-${GEOS_VERSION}.tar.bz2

# Navigate into the GEOS directory
WORKDIR geos-${GEOS_VERSION}

# Configure, build and install GEOS
RUN ./configure \
    && make \
    && make install \
    && ldconfig

# Navigate back to the root directory
WORKDIR /

# Clean up unnecessary files
RUN rm -rf geos-${GEOS_VERSION} \
    && apt-get remove -y build-essential wget \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*