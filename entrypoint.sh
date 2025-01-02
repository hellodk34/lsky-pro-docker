#!/bin/bash
set -eu

if [ -e '/var/www/lsky' ]; then
    cp -af /var/www/lsky/* /var/www/html/
    cp -af /var/www/lsky/.env.example /var/www/html
    rm -rf /var/www/lsky
fi
    chown -R www-data /var/www/html
    chgrp -R www-data /var/www/html
    chmod -R 755 /var/www/html/

exec "$@"
