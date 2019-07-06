ifneq (,)
.error This Makefile requires GNU Make.
endif

.PHONY: build rebuild lint test _test-php-cs-fixer-version _test-php-version _test-run _get-php-version tag pull login push enter

CURRENT_DIR = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
CURRENT_PHP_VERSION =

DIR = .
FILE = Dockerfile
IMAGE = cytopia/php-cs-fixer
TAG = latest

PHP = latest
PCF = latest

build:
ifeq ($(PCF),1)
ifeq ($(PHP),latest)
	@# PHP CS Fixer version 1 goes only up to PHP 7.1
	docker build --build-arg PHP=7.1-cli-alpine --build-arg PCF=$(PCF) -t $(IMAGE) -f $(DIR)/$(FILE) $(DIR)
else
	docker build --build-arg PHP=$(PHP)-cli-alpine --build-arg PCF=$(PCF) -t $(IMAGE) -f $(DIR)/$(FILE) $(DIR)
endif
else
ifeq ($(PHP),latest)
	docker build --build-arg PHP=7-cli-alpine --build-arg PCF=$(PCF) -t $(IMAGE) -f $(DIR)/$(FILE) $(DIR)
else
	docker build --build-arg PHP=$(PHP)-cli-alpine --build-arg PCF=$(PCF) -t $(IMAGE) -f $(DIR)/$(FILE) $(DIR)
endif
endif

rebuild: pull
ifeq ($(PCF),1)
ifeq ($(PHP),latest)
	@# PHP CS Fixer version 1 goes only up to PHP 7.1
	docker build --no-cache --build-arg PHP=7.1-cli-alpine --build-arg PCF=$(PCF) -t $(IMAGE) -f $(DIR)/$(FILE) $(DIR)
else
	docker build --no-cache --build-arg PHP=$(PHP)-cli-alpine --build-arg PCF=$(PCF) -t $(IMAGE) -f $(DIR)/$(FILE) $(DIR)
endif
else
ifeq ($(PHP),latest)
	docker build --no-cache --build-arg PHP=7-cli-alpine --build-arg PCF=$(PCF) -t $(IMAGE) -f $(DIR)/$(FILE) $(DIR)
else
	docker build --no-cache --build-arg PHP=$(PHP)-cli-alpine --build-arg PCF=$(PCF) -t $(IMAGE) -f $(DIR)/$(FILE) $(DIR)
endif
endif

lint:
	@docker run --rm -v $(CURRENT_DIR):/data cytopia/file-lint file-cr --text --ignore '.git/,.github/,tests/' --path .
	@docker run --rm -v $(CURRENT_DIR):/data cytopia/file-lint file-crlf --text --ignore '.git/,.github/,tests/' --path .
	@docker run --rm -v $(CURRENT_DIR):/data cytopia/file-lint file-trailing-single-newline --text --ignore '.git/,.github/,tests/' --path .
	@docker run --rm -v $(CURRENT_DIR):/data cytopia/file-lint file-trailing-space --text --ignore '.git/,.github/,tests/' --path .
	@docker run --rm -v $(CURRENT_DIR):/data cytopia/file-lint file-utf8 --text --ignore '.git/,.github/,tests/' --path .
	@docker run --rm -v $(CURRENT_DIR):/data cytopia/file-lint file-utf8-bom --text --ignore '.git/,.github/,tests/' --path .

test:
	@$(MAKE) --no-print-directory _test-php-cs-fixer-version
	@$(MAKE) --no-print-directory _test-php-version
	@$(MAKE) --no-print-directory _test-run

_test-php-cs-fixer-version:
	@echo "------------------------------------------------------------"
	@echo "- Testing correct phpcs version"
	@echo "------------------------------------------------------------"
	@echo "Fetching latest version from GitHub"; \
	if [ "$(PCF)" = "latest" ]; then \
		LATEST="$$( \
			curl -L -sS https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases \
				| tac | tac \
				| grep -Eo 'tag/v?[.0-9]+?\.[.0-9]+\"' \
				| grep -Eo '[.0-9]+' \
				| sort -u \
				| tail -1 \
		)"; \
		echo "Testing for latest: $${LATEST}"; \
		if ! docker run --rm $(IMAGE) --version | grep -E "^PHP CS Fixer (version)?$${LATEST}"; then \
			echo "Failed"; \
			exit 1; \
		fi; \
	else \
		echo "Testing for tag: $(PCF).x.x"; \
		if ! docker run --rm $(IMAGE) --version | grep -E "^PHP CS Fixer (version[[:space:]])?$(PCF)\.[.0-9]+"; then \
			echo "Failed"; \
			exit 1; \
		fi; \
	fi; \
	echo "Success"; \

_test-php-version: _get-php-version
	@echo "------------------------------------------------------------"
	@echo "- Testing correct PHP version"
	@echo "------------------------------------------------------------"
	@if [ "$(PCF)" = "1" ] && [ "$(PHP)" = "latest" ]; then \
		echo "Testing for tag: 7.1.x"; \
		if ! docker run --rm --entrypoint=php $(IMAGE) --version | head -1 | grep -E "^PHP[[:space:]]+7\.1\.[.0-9]+[[:space:]]"; then \
			echo "Failed"; \
			exit 1; \
		fi; \
	else \
		echo "Testing for tag: $(CURRENT_PHP_VERSION)"; \
		if ! docker run --rm --entrypoint=php $(IMAGE) --version | head -1 | grep -E "^PHP[[:space:]]+$(CURRENT_PHP_VERSION)([.0-9]+)?"; then \
			echo "Failed"; \
			exit 1; \
		fi; \
	fi; \
	echo "Success"; \

_test-run:
	@echo "------------------------------------------------------------"
	@echo "- Testing phpcs (success)"
	@echo "------------------------------------------------------------"
	@if ! docker run --rm -v $(CURRENT_DIR)/tests/ok:/data $(IMAGE) fix --dry-run --diff .; then \
		echo "Failed"; \
		exit 1; \
	fi; \
	echo "Success";
	@echo "------------------------------------------------------------"
	@echo "- Testing phpcs (failure)"
	@echo "------------------------------------------------------------"
	@if docker run --rm -v $(CURRENT_DIR)/tests/fail:/data $(IMAGE) fix --dry-run --diff .; then \
		echo "Failed"; \
		exit 1; \
	fi; \
	echo "Success";

tag:
	docker tag $(IMAGE) $(IMAGE):$(TAG)

pull:
	@echo "Pull base image"
	@grep -E '^\s*FROM' Dockerfile \
		| sed -e 's/^FROM//g' -e 's/[[:space:]]*as[[:space:]]*.*$$//g' \
		| head -1 \
		| xargs -n1 docker pull;
	@echo "Pull target image"
ifeq ($(PCF),1)
ifeq ($(PHP),latest)
	@# PHP CS Fixer version 1 goes only up to PHP 7.1
	docker pull php:7.1-cli-alpine
else
	docker pull php:$(PHP)-cli-alpine
endif
else
ifeq ($(PHP),latest)
	docker pull php:7-cli-alpine
else
	docker pull php:$(PHP)-cli-alpine
endif
endif




login:
	yes | docker login --username $(USER) --password $(PASS)

push:
	@$(MAKE) tag TAG=$(TAG)
	docker push $(IMAGE):$(TAG)

enter:
	docker run --rm --name $(subst /,-,$(IMAGE)) -it --entrypoint=/bin/sh $(ARG) $(IMAGE):$(TAG)

# Fetch latest available PHP version for cli-alpine
_get-php-version:
	$(eval CURRENT_PHP_VERSION = $(shell \
		if [ "$(PHP)" = "latest" ]; then \
			curl -L -sS https://hub.docker.com/api/content/v1/products/images/php \
				| tac | tac \
				| grep -Eo '`[.0-9]+-cli-alpine' \
				| grep -Eo '[.0-9]+' \
				| sort -u \
				| tail -1; \
		else \
			echo $(PHP); \
		fi; \
	))
