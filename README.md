# What is Webox?

Webox (`abbreviation for web-box`) is a customized lnmp server. It supports running on most linux distributions, such as alpine, CentOS, Debian, and Ubuntu.

Webox contains the following modules: mysql, nginx, nodejs, php, redis. And some popular plug-ins have been added, such as geoip2, imagick ...

# Simple Usage

## install and start nginx/mysql/redis/php

```shell
wget -qO- http://get.vmlu.com/webox/wb-install | sh
/opt/webox/service start
```

## service management command

```shell
/opt/webox/service [nginx|mysql|redis|php] [start|stop|restart|reload]
```

## put your files to host's webroot

If the domain is `www.anrip.net`, the webroot will be `/opt/webox/var/www/default/net.anrip.www/`

# Manual Control Services

## fix ENV to run commands such as `mysql`

```shell
PATH=/opt/webox/bin:/opt/webox/sbin:$PATH
```

## configure the modules you need

please edit the config files in `/opt/webox/etc/*`, then reload the service

# Important Notice

## don't forget change mysql password

```shell
mysqladmin -u root password a1B2c3E4
```

# More Issues

See https://www.anrip.com/webox for more issues
