#!/usr/bin/env bash

# NOTE: Parsing curl to tac to circumnvent "failed writing body"
# https://stackoverflow.com/questions/16703647/why-curl-return-and-error-23-failed-writing-body

set -e
set -u
set -o pipefail

SCRIPT_PATH="$( cd "$(dirname "$0")" && pwd -P )"
BLIBOX_PATH="$( cd "${SCRIPT_PATH}/../.." && pwd -P )"
# shellcheck disable=SC1090
. "${SCRIPT_PATH}/../scripts/.lib.sh"

RETRIES=10
DISABLED_VERSIONS=("5.3" "7.4" "8.0")
DISABLED_MYSQL_VERSIONS=("mysql-8.0" "percona-8.0")


echo
echo "# --------------------------------------------------------------------------------------------------"
echo "# [Framework] Drupal 7.x-dev"
echo "# --------------------------------------------------------------------------------------------------"
echo


# -------------------------------------------------------------------------------------------------
# Pre-check
# -------------------------------------------------------------------------------------------------

PHP_VERSION="$( get_php_version "${BLIBOX_PATH}" )"
if [[ ${DISABLED_VERSIONS[*]} =~ ${PHP_VERSION} ]]; then
	printf "[SKIP] Skipping all checks for PHP %s\\n" "${PHP_VERSION}"
	exit 0
fi

MYSQL_VERSION="$( "${SCRIPT_PATH}/../scripts/env-getvar.sh" "MYSQL_SERVER" )"
if [[ ${DISABLED_MYSQL_VERSIONS[*]} =~ ${MYSQL_VERSION} ]]; then
	printf "[SKIP] Skipping all checks for MySQL %s\\n" "${MYSQL_VERSION}"
	exit 0
fi

DRUSH=
if run "docker-compose exec --user blibox -T php bash -c 'command -v drush'" "1" "${BLIBOX_PATH}"; then
	DRUSH=drush
elif run "docker-compose exec --user blibox -T php bash -c 'command -v drush10'" "1" "${BLIBOX_PATH}"; then
	DRUSH=drush10
elif run "docker-compose exec --user blibox -T php bash -c 'command -v drush9'" "1" "${BLIBOX_PATH}"; then
	DRUSH=drush9
elif run "docker-compose exec --user blibox -T php bash -c 'command -v drush8'" "1" "${BLIBOX_PATH}"; then
	DRUSH=drush8
elif run "docker-compose exec --user blibox -T php bash -c 'command -v drush7'" "1" "${BLIBOX_PATH}"; then
	DRUSH=drush7
fi
if [ -z "${DRUSH}" ]; then
	>&2 echo "Error, no drush command found."
	exit 1
fi


# -------------------------------------------------------------------------------------------------
# ENTRYPOINT
# -------------------------------------------------------------------------------------------------

###
### Get required env values
###
MYSQL_ROOT_PASSWORD="$( "${SCRIPT_PATH}/../scripts/env-getvar.sh" "MYSQL_ROOT_PASSWORD" )"
TLD_SUFFIX="$( "${SCRIPT_PATH}/../scripts/env-getvar.sh" "TLD_SUFFIX" )"


# Setup Drupal project
run "docker-compose exec --user blibox -T php bash -c 'mkdir -p /shared/httpd/drupal'" "${RETRIES}" "${BLIBOX_PATH}"
run "docker-compose exec --user blibox -T php bash -c 'cd /shared/httpd/drupal; sudo rm -rf drupal; composer create-project --no-interaction --prefer-dist drupal-composer/drupal-project drupal 7.x-dev'" "${RETRIES}" "${BLIBOX_PATH}"
run "docker-compose exec --user blibox -T php bash -c 'cd /shared/httpd/drupal; ln -sf drupal/web htdocs'" "${RETRIES}" "${BLIBOX_PATH}"
run "docker-compose exec --user blibox -T php mysql -u root -h mysql --password=\"${MYSQL_ROOT_PASSWORD}\" -e \"DROP DATABASE IF EXISTS my_drupal; CREATE DATABASE my_drupal;\"" "${RETRIES}" "${BLIBOX_PATH}"

# Configure Drupal
run "docker-compose exec --user blibox -T php bash -c 'cd /shared/httpd/drupal/htdocs/; ${DRUSH} site-install standard --db-url='mysql://root:${MYSQL_ROOT_PASSWORD}@mysql/my_drupal' --site-name=Example -y'" "${RETRIES}" "${BLIBOX_PATH}"

# Test Drupal
if ! run "docker-compose exec --user blibox -T php curl -sS --fail 'http://drupal.${TLD_SUFFIX}' | tac | tac | grep 'Welcome to Example'" "${RETRIES}" "${BLIBOX_PATH}"; then
	run "docker-compose exec --user blibox -T php curl 'http://drupal.${TLD_SUFFIX}' || true"
	exit 1
fi