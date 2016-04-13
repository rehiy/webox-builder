server {

    listen 80 default;

    include common/21.server_status;
    include common/22.server_error_page;

    set $pooldir /srv/webroot/default;

    if ($host ~ ^([^\.]+)\.([^\.]+)$) {
        rewrite ^/?(.*)$ http://www.$host/$1 last;
    }
    if ($host ~* ([^\.]+)\.([^\.]+)\.([a-z]+)$) {
        set $webroot $pooldir/$3.$2/$1;
    }

    if (!-d $webroot) {
        set $webroot $pooldir/sample;
    }

    root  $webroot;
    index index.html index.htm index.php;
    #try_files $uri $uri/ /index.php?q=$uri&$args;

    include suffix/default.*.inc;

}
