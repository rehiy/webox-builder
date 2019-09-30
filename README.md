# Feature

WeBox is a lnmp server based on ubuntu, debian or alpine. contains the following modules: nginx, mysql, redis, php5/php7. And some popular plug-ins have been added, such as redis, geoip2, imagick ...

# Simple Usage

## auto prepare and start nginx/mysql/redis/php7

```shell
wget -qO- http://get.vmlu.com/webox/wb-install | sudo sh
sudo /srv/service start
```

## the following commands are supported

```shell
/srv/service [start|stop|restart|reload]
```

## put your files to host's webroot path

If the host is `www.anrip.com`, the webroot will be `/srv/htdoc/defualt/web/com.anrip.www/`

# Manual Control Services

## fix global runtime

```shell
. /srv/webox/runtime
```

## control the modules you need

```shell
wkit [nginx|mysql|redis|php5|php7] [start|stop|restart|reload]
```

## configure the modules you need

please edit the config files in /srv/app/etc/\*, then reload the service

# Important Notice

## don't forget change mysql password

```shell
mysqladmin -u root password a1B2c3E4
```

# More Issues

See http://www.anrip.com/webox for more issues
