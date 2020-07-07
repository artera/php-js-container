FROM php:7.4-alpine
RUN apk --no-cache add \
    git \
    jq \
    nodejs \
    nodejs-npm \
    yarn \
    bzip2 \
    bzip2-dev \
    enchant \
    enchant-dev \
    libpng \
    libpng-dev \
    gmp \
    gmp-dev \
    imap \
    c-client \
    imap-dev \
    icu \
    icu-dev \
    aspell \
    aspell-dev \
    libzip \
    libzip-dev \
    tidyhtml-libs \
    tidyhtml-dev \
    openldap-dev \
    make \
    python3 \
    mariadb-client \
    postgresql-client
RUN docker-php-ext-install -j$(nproc) bcmath bz2 calendar \
    enchant exif gd gettext gmp imap intl ldap opcache \
    pcntl pdo_mysql pspell sockets tidy zip mysqli
RUN apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS && \
    pecl install pcov uopz && docker-php-ext-enable pcov uopz && \
    apk del --no-network \
        .phpize-deps \
        bzip2-dev \
        enchant-dev \
        libpng-dev \
        gmp-dev \
        imap-dev \
        icu-dev \
        aspell-dev \
        libzip-dev \
        tidyhtml-dev \
        openldap-dev
COPY composer-setup.sh /usr/local/bin/composer-setup.sh
RUN /usr/local/bin/composer-setup.sh && \
    rm -f /usr/local/bin/composer-setup.sh && \
    composer global require --no-plugins --no-scripts "squizlabs/php_codesniffer=*" && \
    rm -rf /root/.composer/cache
RUN npm install -g pnpm
RUN pip3 --no-cache-dir install jinja2 requests
ENV PATH="/root/.composer/vendor/bin:${PATH}"
CMD sh
