#!/bin/sh
# 参考：https://github.com/jkaninda/nginx-php-fpm/blob/main/src/supervisor/supervisord.conf

echo ""
echo "***********************************************************"
echo " Starting NGINX PHP-FPM Docker Container                   "
echo "***********************************************************"

set -e

## Check if the supervisor config file exists
if [ -f /var/www/html/conf/worker/supervisor.conf ]; then
    echo "Custom supervisor config found"
    cp /var/www/html/conf/worker/supervisor.conf /etc/supervisor/conf.d/supervisor.conf
    else
    echo "${Red} Supervisor.conf not found"
    echo "${Green} If you want to add more supervisor configs, create config file in /var/www/html/conf/worker/supervisor.conf"
    echo "${Green} Start supervisor with default config..."
    fi


echo ""
echo "**********************************"
echo "     Starting Supervisord...     "
echo "***********************************"
supervisord -c /etc/supervisor/supervisord.conf