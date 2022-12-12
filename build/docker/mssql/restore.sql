USE master;
ALTER DATABASE [contentbox]
  SET OFFLINE WITH ROLLBACK IMMEDIATE;
DROP DATABASE [contentbox];
RESTORE DATABASE [contentbox]
   FROM DISK='/tmp/mssql/contentbox.bak'
   WITH REPLACE,
   MOVE 'contentbox' TO '/var/opt/mssql/data/contentbox_data.mdf',
   MOVE 'contentbox_Log' TO '/var/opt/mssql/data/contentbox_log.ldf';
ALTER DATABASE [contentbox]
   SET ONLINE;
ALTER DATABASE [contentbox]
   SET COMPATIBILITY_LEVEL = 140;
USE [contentbox];