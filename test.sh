#!/bin/sh
set -e
sh wait-for.sh db:3306 --timeout=120 -- echo "db ready"
composer test -- --fail-fast -vvv
