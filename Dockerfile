FROM php:8-cli-alpine
RUN apk --no-cache add \
    git \
    jq \
    nodejs \
    nodejs-npm \
    yarn \
    bzip2 \
    bzip2-dev \
    libpng \
    libpng-dev \
    gcc \
    libffi \
    libffi-dev \
    gmp \
    gmp-dev \
    imap \
    c-client \
    imap-dev \
    icu \
    icu-dev \
    aspell \
    aspell-dev \
    gettext-dev \
    libzip \
    libzip-dev \
    tidyhtml-libs \
    tidyhtml-dev \
    openldap-dev \
    make \
    python3 \
    py3-pip \
    mariadb-client \
    postgresql-client
RUN docker-php-ext-install -j$(nproc) bcmath bz2 calendar \
    exif ffi gd gettext gmp imap intl ldap opcache \
    pcntl pdo_mysql pspell sockets tidy zip mysqli
RUN apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS && \
    pecl install pcov && docker-php-ext-enable pcov && \
    apk del --no-network \
        .phpize-deps \
        bzip2-dev \
        libpng-dev \
        libffi-dev \
        gmp-dev \
        imap-dev \
        icu-dev \
        aspell-dev \
        gettext-dev \
        libzip-dev \
        tidyhtml-dev \
        openldap-dev
COPY composer-setup.sh /usr/local/bin/composer-setup.sh
RUN /usr/local/bin/composer-setup.sh && \
    rm -f /usr/local/bin/composer-setup.sh && \
    composer global require --no-interaction --no-plugins --no-scripts "squizlabs/php_codesniffer=*" && \
    rm -rf /root/.composer/cache
RUN npm install -g pnpm
RUN sed 's/lockFilename, { realpath: false }/lockFilename, { realpath: false, stale: 300000 }/' -i /usr/share/node_modules/yarn/lib/cli.js
RUN pip --no-cache-dir install jinja2 requests
ENV PATH="/root/.composer/vendor/bin:${PATH}"
CMD sh
