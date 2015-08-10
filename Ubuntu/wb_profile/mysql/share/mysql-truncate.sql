USE mysql;

TRUNCATE `columns_priv`;

TRUNCATE `db`;

TRUNCATE `tables_priv`;

TRUNCATE `user`;

INSERT INTO `user` VALUES
('localhost',	'root',	'',	'Y',	'Y',	'Y',	'Y',	'Y',	'Y',	'Y',	'Y',	'Y',	'Y',	'Y',	'Y',	'Y',	'Y',	'Y',	'Y',	'Y',	'Y',	'Y',	'Y',	'Y',	'Y',	'Y',	'Y',	'Y',	'Y',	'Y',	'Y',	'Y',	'',	'',	'',	'',	0,	0,	0,	0,	'mysql_native_password',	'',	'N');
