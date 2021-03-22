ARG PHP
FROM php:${PHP}-cli-alpine as builder

# Install build dependencies
RUN set -eux \
	&& apk --no-cache add \
		curl \
		git \
	&& git clone https://github.com/FriendsOfPHP/PHP-CS-Fixer

ARG PCF
RUN set -eux \
	&& cd PHP-CS-Fixer \
	&& if [ "${PCF}" = "latest" ]; then \
		VERSION="$( git tag | grep -E '^v?[.0-9]+$' | sort -V | tail -1 )"; \
	else \
		VERSION="$( git tag | grep -E "^v?${PCF}\.[.0-9]+\$" | sort -V | tail -1 )"; \
	fi \
	&& echo "Version: ${VERSION}" \
	&& curl -sS -L https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/${VERSION}/php-cs-fixer.phar -o /php-cs-fixer \
	&& chmod +x /php-cs-fixer \
	&& mv /php-cs-fixer /usr/bin/php-cs-fixer

RUN set -eux \
	&& php-cs-fixer --version


ARG PHP
FROM php:${PHP}-cli-alpine as production
LABEL \
	maintainer="cytopia <cytopia@everythingcli.org>" \
	repo="https://github.com/cytopia/docker-php-cs-fixer"

COPY --from=builder /usr/bin/php-cs-fixer /usr/bin/php-cs-fixer
ENV WORKDIR /data
WORKDIR /data

ENTRYPOINT ["php-cs-fixer"]
CMD ["--version"]
