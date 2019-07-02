ARG PHP
FROM php:7.1 as builder

# Install build dependencies
RUN set -eux \
	&& DEBIAN_FRONTEND=noninteractive apt-get update -qq \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests \
		ca-certificates \
		curl \
		git \
	&& git clone https://github.com/FriendsOfPHP/PHP-CS-Fixer

ARG PCF
RUN set -eux \
	&& cd PHP-CS-Fixer \
	&& if [ "${PCF}" = "latest" ]; then \
		VERSION="$( git describe --abbrev=0 --tags )"; \
	else \
		VERSION="$( git tag | grep -E "^v?${PCF}\.[.0-9]+\$" | sort -V | tail -1 )"; \
	fi \
	&& curl -sS -L https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/${VERSION}/php-cs-fixer.phar -o /php-cs-fixer \
	&& chmod +x /php-cs-fixer \
	&& mv /php-cs-fixer /usr/bin/php-cs-fixer

RUN set -eux \
	&& php-cs-fixer --version


FROM php:${PHP} as production
LABEL \
	maintainer="cytopia <cytopia@everythingcli.org>" \
	repo="https://github.com/cytopia/docker-php-cs-fixer"

COPY --from=builder /usr/bin/php-cs-fixer /usr/bin/php-cs-fixer
ENV WORKDIR /data
WORKDIR /data

ENTRYPOINT ["php-cs-fixer"]
CMD ["--version"]
