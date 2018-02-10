;;;;;;;;;;;;;;;;;;;;
; Pool Definitions ;
;;;;;;;;;;;;;;;;;;;;

[default]

; Per pool prefix

prefix = /srv/php5/var

; Unix user/group of processes

user = www-data
group = www-data

listen = run/$pool.sock

; Set permissions for unix socket, if one is used.

listen.owner = www-data
listen.group = www-data
listen.mode = 0660

; Choose how the process manager will control the number of child processes.

pm = dynamic

pm.max_children = 32
pm.start_servers = 4
pm.min_spare_servers = 2
pm.max_spare_servers = 6
pm.process_idle_timeout = 30s
pm.max_requests = 10240

; The URI to view the FPM status page. If this value is not set, no URI will be
; recognized as a status page.

pm.status_path = /status/php5/$pool

; The access log file

;access.log = log/$pool.access.log

; The log file for slow requests

slowlog = log/$pool.slow.log

; The timeout for serving a single request after which a PHP backtrace will be
; dumped to the 'slowlog' file.

request_slowlog_timeout = 60s

; The timeout for serving a single request after which the worker process will
; be killed.

request_terminate_timeout = 0

; Pass environment variables like LD_LIBRARY_PATH. All $VARIABLEs are taken from
; the current environment.

env[PATH] = /srv/webox/bin:/usr/bin:/bin

; Additional php.ini defines, specific to this pool of workers. These settings
; overwrite the values previously defined in the php.ini.

php_admin_value[open_basedir]      = /srv/webroot/$pool/
php_admin_value[sys_temp_dir]      = /srv/webroot/$pool/var
php_admin_value[upload_tmp_dir]    = /srv/webroot/$pool/var/upload
php_admin_value[session.save_path] = /srv/webroot/$pool/var/session

php_admin_value[error_log] = /srv/webroot/$pool/var/php_error.log
php_admin_value[mail.log]  = /srv/webroot/$pool/var/php_mail.log