#!/bin/bash

make login USER="${DOCKER_USERNAME}" PASS="${DOCKER_PASSWORD}"
if [ -n "${TAG}" ]; then
  if [ "${PCF}" == "latest" ] && [ "${PHP}" == "latest" ]; then
    make push TAG="latest-${TAG}"
  else
    if [ "${PHP}" == "latest" ]; then
      make push TAG="${PCF}-${TAG}"
    else
      make push TAG="${PCF}-php${PHP}-${TAG}"
    fi
  fi
elif [ "${BRANCH}" == "master" ]; then
  if [ "${PCF}" == "latest" ] && [ "${PHP}" == "latest" ]; then
    make push TAG=latest
  else
    if [ "${PHP}" == "latest" ]; then
      make push TAG=${PCF}
    else
      make push TAG=${PCF}-php${PHP}
    fi
  fi
elif [[ ${BRANCH} =~ ^(release-[.0-9]+)$ ]]; then
  if [ "${PCF}" == "latest" ] && [ "${PHP}" == "latest" ]; then
    make push TAG="latest-${BRANCH}"
  else
    if [ "${PHP}" == "latest" ]; then
      make push TAG="${PCF}-${BRANCH}"
    else
      make push TAG="${PCF}-php${PHP}-${BRANCH}"
    fi
  fi
else
  echo "Skipping branch ${BRANCH}"
fi
