#!/bin/sh
# 参考：https://github.com/jkaninda/nginx-php-fpm/blob/main/src/supervisor/supervisord.conf

echo ""
echo "***********************************************************"
echo " Starting NGINX PHP-FPM Docker Container                   "
echo "***********************************************************"

echo ""
echo "**********************************"
echo "     Starting Supervisord...     "
echo "***********************************"
supervisord -c /etc/supervisor/supervisord.conf