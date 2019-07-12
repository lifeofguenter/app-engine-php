FROM debian:jessie-slim

ARG DEBIAN_FRONTEND="noninteractive"
ARG CLOUDSDK_CORE_DISABLE_PROMPTS="1"
ARG CLOUDSDK_VERSION="253.0.0"
ARG PHP_VERSION="5.5.38"
ARG PHP_EXT_APCU_VERSION="4.0.3"
ARG PHP_EXT_MAILPARSE_VERSION="2.1.6"
ARG PHP_EXT_OAUTH_VERSION="1.2.3"
ARG PHP_EXT_MONGO_VERSION="1.6.11"
ARG PHP_EXT_IMAGICK_VERSION="3.1.2"
ARG http_proxy=""

ENV PATH="/google-cloud-sdk/bin:${PATH}"

ENTRYPOINT [ "entrypoint.sh" ]

WORKDIR /app

COPY bin/ /usr/local/bin/

RUN set -ex && \
    if [ ! -z "${http_proxy}" ]; then printf 'Acquire::http::Proxy "%s";\n' "${http_proxy}" | tee -a /etc/apt/apt.conf.d/proxy.conf; fi && \
    apt-get update && \
    apt-get -y install --no-install-recommends \
      make \
      gcc \
      g++ \
      autoconf \
      automake \
      pkg-config \
      libxml2-dev \
      libssl-dev \
      libcurl4-openssl-dev \
      libwebp-dev \
      libjpeg-dev \
      libpng-dev \
      libfreetype6-dev \
      libicu-dev \
      libmcrypt-dev \
      libxslt1-dev \
      libzip-dev \
      libmagickwand-dev \
      protobuf-compiler \
      libprotobuf-dev \
      curl \
      ca-certificates \
      python && \
    ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/MagickWand-config /usr/local/bin/MagickWand-config && \
    apt-get autoclean && \
    apt-get clean

RUN set -ex && \
    curl -fLO "https://www.php.net/distributions/php-${PHP_VERSION}.tar.gz" && \
    tar xf "php-${PHP_VERSION}.tar.gz" && \
    cd "php-${PHP_VERSION}" && \
    ./configure \
      --prefix=/usr \
      --sysconfdir=/etc \
      --localstatedir=/var \
      --with-config-file-path=/etc/php5 \
      --with-config-file-scan-dir=/etc/php5/conf.d \
      --datadir=/usr/share \
      --mandir=/usr/share/man \
      --with-libxml-dir \
      --with-openssl \
      --with-pcre-regex \
      --without-sqlite3 \
      --with-zlib \
      --enable-bcmath \
      --enable-calendar \
      --with-curl=shared \
      --without-cdb \
      --enable-exif \
      --enable-ftp \
      --with-gd \
      --with-jpeg-dir \
      --with-png-dir \
      --with-freetype-dir \
      --enable-gd-native-ttf \
      --with-mhash \
      --enable-intl=shared \
      --enable-fileinfo=shared \
      --enable-mbstring \
      --with-mcrypt \
      --with-mysql \
      --with-mysqli \
      --with-pdo-mysql \
      --without-pdo-sqlite \
      --enable-soap \
      --enable-sockets \
      --with-xsl \
      --enable-zip \
      --with-iconv-dir \
      --enable-opcache \
      --enable-shmop \
      --disable-phar \
      --without-pear && \
    make -j "$(nproc)" && \
    make install && \
    cd .. && \
    rm -rf "php-${PHP_VERSION}"*

RUN set -ex && \
    curl -fLO "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUDSDK_VERSION}-linux-x86_64.tar.gz" && \
    tar xf "google-cloud-sdk-${CLOUDSDK_VERSION}-linux-x86_64.tar.gz" -C / && \
    gcloud components install app-engine-php --quiet && \
    curl -fLO https://github.com/GoogleCloudPlatform/appengine-php-extension/archive/master.tar.gz && \
    tar xf master.tar.gz && \
    cd appengine-php-extension-master && \
    protoc --cpp_out=. remote_api.proto && \
    protoc --cpp_out=. urlfetch_service.proto && \
    phpize && \
    ./configure --enable-gae --with-protobuf_inc=/usr/include/ --with-protobuf_lib=/usr/lib/ && \
    make && \
    make install && \
    cd .. && \
    php-ext-compile.sh apcu && \
    php-ext-compile.sh mailparse && \
    php-ext-compile.sh oauth && \
    php-ext-compile.sh mongo && \
    php-ext-compile.sh imagick && \
    rm -rf \
      "google-cloud-sdk-${CLOUDSDK_VERSION}-linux-x86_64.tar.gz" \
      master.tar.gz \
      appengine-php-extension-master \
      package.xml

RUN set -ex && \
    mkdir -p \
      /etc/php5/conf.d/ \
      /storage
