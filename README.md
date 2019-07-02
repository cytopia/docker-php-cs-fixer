# Docker image for `php-cs-fixer`

[![Build Status](https://travis-ci.com/cytopia/docker-php-cs-fixer.svg?branch=master)](https://travis-ci.com/cytopia/docker-php-cs-fixer)
[![Tag](https://img.shields.io/github/tag/cytopia/docker-php-cs-fixer.svg)](https://github.com/cytopia/docker-php-cs-fixer/releases)
[![](https://images.microbadger.com/badges/version/cytopia/php-cs-fixer:latest.svg?&kill_cache=1)](https://microbadger.com/images/cytopia/php-cs-fixer:latest "php-cs-fixer")
[![](https://images.microbadger.com/badges/image/cytopia/php-cs-fixer:latest.svg?&kill_cache=1)](https://microbadger.com/images/cytopia/php-cs-fixer:latest "php-cs-fixer")
[![](https://img.shields.io/badge/github-cytopia%2Fdocker--php--cs--fixer-red.svg)](https://github.com/cytopia/docker-php-cs-fixer "github.com/cytopia/docker-php-cs-fixer")
[![License](https://img.shields.io/badge/license-MIT-%233DA639.svg)](https://opensource.org/licenses/MIT)

> #### All [#awesome-ci](https://github.com/topics/awesome-ci) Docker images
>
> [ansible](https://github.com/cytopia/docker-ansible) **•**
> [ansible-lint](https://github.com/cytopia/docker-ansible-lint) **•**
> [awesome-ci](https://github.com/cytopia/awesome-ci) **•**
> [black](https://github.com/cytopia/docker-black) **•**
> [checkmake](https://github.com/cytopia/docker-checkmake) **•**
> [eslint](https://github.com/cytopia/docker-eslint) **•**
> [file-lint](https://github.com/cytopia/docker-file-lint) **•**
> [gofmt](https://github.com/cytopia/docker-gofmt) **•**
> [goimports](https://github.com/cytopia/docker-php-cs-fixer) **•**
> [golint](https://github.com/cytopia/docker-golint) **•**
> [jsonlint](https://github.com/cytopia/docker-jsonlint) **•**
> [phpcbf](https://github.com/cytopia/docker-phpcbf) **•**
> [phpcs](https://github.com/cytopia/docker-phpcs) **•**
> [php-cs-fixer](https://github.com/cytopia/docker-php-cs-fixer) **•**
> [pycodestyle](https://github.com/cytopia/docker-pycodestyle) **•**
> [pylint](https://github.com/cytopia/docker-pylint) **•**
> [terraform-docs](https://github.com/cytopia/docker-terraform-docs) **•**
> [terragrunt](https://github.com/cytopia/docker-terragrunt) **•**
> [yamllint](https://github.com/cytopia/docker-yamllint)


> #### All [#awesome-ci](https://github.com/topics/awesome-ci) Makefiles
>
> Visit **[cytopia/makefiles](https://github.com/cytopia/makefiles)** for seamless project integration, minimum required best-practice code linting and CI.

View **[Dockerfile](https://github.com/cytopia/docker-php-cs-fixer/blob/master/Dockerfile)** on GitHub.

[![Docker hub](http://dockeri.co/image/cytopia/php-cs-fixer?&kill_cache=1)](https://hub.docker.com/r/cytopia/php-cs-fixer)

Tiny Alpine-based multistage-builld dockerized version of [php-cs-fixer](https://github.com/FriendsOfPHP/PHP-CS-Fixer)<sup>[1]</sup>.
The image is built nightly against multiple stable versions and pushed to Dockerhub.

<sup>[1] Official project: https://github.com/FriendsOfPHP/PHP-CS-Fixer</sup>


## Available Docker image versions

Docker images for PHP Coding Standards Fixer come with all available PHP versions. In doubt use `latest` tag.

#### Latest stable php-cs-fixer version
| Docker tag      | php-cs-fixer version         | PHP version           |
|-----------------|-----------------------|-----------------------|
| `latest`        | latest stable         | latest stable         |
| `latest-php7.3` | latest stable         | latest stable `7.3.x` |
| `latest-php7.2` | latest stable         | latest stable `7.2.x` |
| `latest-php7.1` | latest stable         | latest stable `7.1.x` |
| `latest-php7.0` | latest stable         | latest stable `7.0.x` |
| `latest-php5.6` | latest stable         | latest stable `5.6.x` |

#### Latest stable php-cs-fixer `2.x.x` version
| Docker tag      | php-cs-fixer version         | PHP version           |
|-----------------|-----------------------|-----------------------|
| `2`             | latest stable `2.x.x` | latest stable         |
| `2-php7.3`      | latest stable `2.x.x` | latest stable `7.3.x` |
| `2-php7.2`      | latest stable `2.x.x` | latest stable `7.2.x` |
| `2-php7.1`      | latest stable `2.x.x` | latest stable `7.1.x` |
| `2-php7.0`      | latest stable `2.x.x` | latest stable `7.0.x` |
| `2-php5.6`      | latest stable `2.x.x` | latest stable `5.6.x` |

#### Latest stable php-cs-fixer `1.x.x` version
| Docker tag      | php-cs-fixer version         | PHP version           |
|-----------------|-----------------------|-----------------------|
| `1`             | latest stable `1.x.x` | latest stable supported version |
| `1-php7.1`      | latest stable `1.x.x` | latest stable `7.1.x` |
| `1-php7.0`      | latest stable `1.x.x` | latest stable `7.0.x` |
| `1-php5.6`      | latest stable `1.x.x` | latest stable `5.6.x` |


## Docker mounts

The working directory inside the Docker container is **`/data/`** and should be mounted locally to
the root of your project.


## Usage

### Generic
```
$ docker run --rm cytopia/php-cs-fixer --help

Usage:
  list [options] [--] [<namespace>]

Arguments:
  namespace            The namespace name

Options:
      --raw            To output raw command list
      --format=FORMAT  The output format (txt, xml, json, or md) [default: "txt"]

Help:
  The list command lists all commands:

    php /usr/bin/php-cs-fixer list

  You can also display the commands for a specific namespace:

    php /usr/bin/php-cs-fixer list test

  You can also output the information in other formats by using the --format option:

    php /usr/bin/php-cs-fixer list --format=xml

  It's also possible to get raw list of commands (useful for embedding command runner):

    php /usr/bin/php-cs-fixer list --raw
```

### Dry-run

```bash
$ docker run --rm -v $(pwd):/data cytopia/php-cs-fixer fix --dry-run --diff .
```
```diff
Loaded config default.
Using cache file ".php_cs.cache".
   1) fail.php
      ---------- begin diff ----------
--- Original
+++ New
@@ @@
 <?php

  echo "test";

-if (  1 ==2) {
- echo "asd"; }
+if (1 ==2) {
+    echo "asd";
+}


      ----------- end diff -----------


Checked all files in 0.004 seconds, 10.000 MB memory used
```

### Example Makefile
You can add the following Makefile to your project for easy generation of php-cs-fixer.

```make
ifneq (,)
.error This Makefile requires GNU Make.
endif

.PHONY: lint _lint-pcf _update-pcf

CURRENT_DIR = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
PCF_VERSION = 2

lint:
	@echo "################################################################################"
	@echo "# Linting Stage"
	@echo "################################################################################"
	@$(MAKE) --no-print-directory _lint-pcf

_lint-pcf: _update-pcf
	@echo "------------------------------------------------------------"
	@echo " PHP Code Style Fixer"
	@echo "------------------------------------------------------------"
	@if docker run --rm \
		-v $(CURRENT_DIR):/data \
		cytopia/php-cs-fixer:$(PCF_VERSION) \
		fix --dry-run --diff .; then \
		echo "OK"; \
	else \
		echo "Failed"; \
		exit 1; \
	fi

_update-pcf:
	docker pull cytopia/php-cs-fixer:$(PCF_VERSION)
```

### Travis CI integration
```yml
---
sudo: required
services:
  - docker
before_install: true
install: true
script:
  - make lint
```


## Related [#awesome-ci](https://github.com/topics/awesome-ci) projects

### Docker images

Save yourself from installing lot's of dependencies and pick a dockerized version of your favourite
linter below for reproducible local or remote CI tests:

| Docker image | Type | Description |
|--------------|------|-------------|
| [awesome-ci](https://github.com/cytopia/awesome-ci) | Basic | Tools for git, file and static source code analysis |
| [file-lint](https://github.com/cytopia/docker-file-lint) | Basic | Baisc source code analysis |
| [jsonlint](https://github.com/cytopia/docker-jsonlint) | Basic | Lint JSON files **<sup>[1]</sup>** |
| [yamllint](https://github.com/cytopia/docker-yamllint) | Basic | Lint Yaml files |
| [ansible](https://github.com/cytopia/docker-ansible) | Ansible | Multiple versoins of Ansible |
| [ansible-lint](https://github.com/cytopia/docker-ansible-lint) | Ansible | Lint  Ansible |
| [gofmt](https://github.com/cytopia/docker-gofmt) | Go | Format Go source code **<sup>[1]</sup>** |
| [goimports](https://github.com/cytopia/docker-php-cs-fixer) | Go | Format Go source code **<sup>[1]</sup>** |
| [golint](https://github.com/cytopia/docker-golint) | Go | Lint Go code |
| [eslint](https://github.com/cytopia/docker-eslint) | Javascript | Lint Javascript code |
| [checkmake](https://github.com/cytopia/docker-checkmake) | Make | Lint Makefiles |
| [phpcbf](https://github.com/cytopia/docker-phpcbf) | PHP | PHP Code Beautifier and Fixer |
| [phpcs](https://github.com/cytopia/docker-phpcs) | PHP | PHP Code Sniffer |
| [php-cs-fixer](https://github.com/cytopia/docker-php-cs-fixer) | PHP | PHP Coding Standards Fixer |
| [black](https://github.com/cytopia/docker-black) | Python | The uncompromising Python code formatter |
| [pycodestyle](https://github.com/cytopia/docker-pycodestyle) | Python | Python style guide checker |
| [pylint](https://github.com/cytopia/docker-pylint) | Python | Python source code, bug and quality checker |
| [terraform-docs](https://github.com/cytopia/docker-terraform-docs) | Terraform | Terraform doc generator (TF 0.12 ready) **<sup>[1]</sup>** |
| [terragrunt](https://github.com/cytopia/docker-terragrunt) | Terraform | Terragrunt and Terraform |

> **<sup>[1]</sup>** Uses a shell wrapper to add **enhanced functionality** not available by original project.


### Makefiles

Visit **[cytopia/makefiles](https://github.com/cytopia/makefiles)** for dependency-less, seamless project integration and minimum required best-practice code linting for CI.
The provided Makefiles will only require GNU Make and Docker itself removing the need to install anything else.


## License

**[MIT License](LICENSE)**

Copyright (c) 2019 [cytopia](https://github.com/cytopia)
