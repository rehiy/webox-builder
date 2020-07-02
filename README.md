# Feature

WeBox is a lnmp server based on ubuntu, debian or alpine. contains the following modules: nginx, mysql, redis, php. And some popular plug-ins have been added, such as redis, geoip2, imagick ...

# Simple Usage

## auto prepare and start nginx/mysql/redis/php

```shell
wget -qO- http://get.vmlu.com/webox/wb-install | sudo sh
sudo /srv/service start
```

## the following commands are supported

```shell
/srv/service [nginx|mysql|redis|php] [start|stop|restart|reload]
```

## put your files to host's webroot path

If the host is `www.anrip.net`, the webroot will be `/srv/htdoc/defualt/net.anrip.www/`

# Manual Control Services

## fix ENV to run commands such as `mysql`

```shell
. /srv/app/runtime
```

## configure the modules you need

please edit the config files in `/srv/webox/etc/`, then reload the service

# Important Notice

## don't forget change mysql password

```shell
mysqladmin -u root password a1B2c3E4
```

# More Issues

See http://www.anrip.com/webox for more issues
