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

When `auto` are not used, you can manual control the services

## enable the modules you need

```shell
/srv/webox/bin/wkit nginx prepare
/srv/webox/bin/wkit mysql prepare
/srv/webox/bin/wkit redis prepare
/srv/webox/bin/wkit php5 prepare
/srv/webox/bin/wkit php7 prepare
```

## control the modules you need

```shell
/srv/webox/bin/wkit nginx [start|stop|restart|reload]
/srv/webox/bin/wkit mysql [start|stop|restart|reload]
/srv/webox/bin/wkit redis [start|stop|restart|reload]
/srv/webox/bin/wkit php5 [start|stop|restart|reload]
/srv/webox/bin/wkit php7 [start|stop|restart|reload]
```

## configure the modules you need

please edit the config files in /srv/app/etc/\*, then reload the service

# Important Notice

## don't forget change mysql password

```shell
/srv/app/bin/mysqladmin password a1B2c3E4
```

# More Issues

See http://www.anrip.com/webox for more issues
