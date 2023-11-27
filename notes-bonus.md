# Bonus part

Already done the necessary partitions to run the wordpress and DB on the first steps. Be aware of this.

## Lighttpd

```
🧠 Que es Lighttpd❓ Es un servidor web diseñado para ser rápido, seguro, flexible, y fiel a los estándares. Está optimizado para entornos donde la velocidad es muy importante. Esto se debe a que consume menos CPU y memoria RAM que otros servidores.
```
+ sudo apt install lighttpd
+ Permitimos kas conexiones mediante el puerto 80 con el comando `sudo ufw allow 80`
	+ ufw: uncomplicated firewall
	+ check with `sudo ufw status`

## Wordpress

```
🧠 Que es Wordpress❓ Es un sistema de gestión de contenidos enfocado a la creación de cualquier tipo de página web.
1 ◦ Para instalar la última versión de WordPress primero debemos instalar wget y zip. Para ello haremos uso del siguiente comando `sudo apt install wget zip`.
🧠 Que es wget❓ Es una herramienta de línea de comandos que se utiliza para descargar archivos de la web.
🧠 Que es zip❓ Es una utilidad de línea de comandos para comprimir y descomprimir archivos en formato ZIP.
```
+ `sudo apt install wget zip`
+ cd /var/www -> descargar la ultima versión de Wordpress aquí: `sudo wget https://es.wordpress.org/latest-es_Es.zip`
+ `sudo unzip latest-es_ES.zip`
+ renommbrar las carpetas:
	+ `sudo mv html/ html_old/`
	+ `sudo mv wordpress/ html``
+ Establecer permisos en la carpeta html con `sudo chmod -R 755 html`

## Mariadb

```
🧠 Que es MariaDB❓ Es una base de datos. Se utiliza para diversos fines, como el almacenamiento de datos, el comercio electrónico, funciones a nivel empresarial y las aplicaciones de registro.
```
+ `sudo apt install mariadb-server``
+ restringir el acceso al servidor y eliminar cuenta no utilizadas: `sudo mysql_secure_installation`
+ mariadb
	+ CREATE DATABASE wp_database;
	+ SHOW DATABASES;
	+ CREATE USER 'luciama2@localhost' IDENTIFIED BY '12345';
	+ GRANT ALL PRIVILEGES ON wp_database.* TO 'luciama2@localhost';
	+ FLUSH PRIVILEGES
	+ exit

## PHP

```
🧠 Que es PHP❓ Es un lenguaje de programación. Se utiliza principalmente para desarrollar aplicaciones web dinámicas y sitios web interactivos. PHP se ejecuta en el lado del servidor.
```
+ sudo apt install php-cgi php-mysql

### Configuracion wordpress

+ cd /var/www/html
+ copiar el fichero wp-config-sample.php y lo renombraremos wp-congig.php -> `cp wp-config-sample.php wp-config.php`
+ editar el archivo `vim wp-config.php` y modificaremos:
	+ 'database_name_here' > 'wp_database'
	+ 'username_here' > 'luciama2'
	+ 'password_here' > '12345'
+ Habilitamos el moduflo fastcgi-php en Lighttpd para mejorar el rendimiento y la velocidada de las aplicaciones web en el servidor `sudo lighty-enable-mod fastcgi-php`
+ Actualizamos y aplicamos los cambios en la configuración con el comando `sudo service lighttpd force-reload`
+ Una vez hemos completado los pasos anteriores podemos volver a dirigirnos a nuestro navegador y escribiremos `localhost`
+ para ver el sitio de wordpress -> acceder desde el navegador a `localhost`

## Servicio adicional: phpMyAdmin
https://www.tecmint.com/install-lighttpd-in-ubuntu/

+ `sudo apt install phpmyadmin`
+ During installation
	+ Choose to not configure the database w/ dbconfig-common
	+ Use ligghttpd as a webbserver to reconfigure automatically
+ go to `http://localhost/phpmyadmin` and insert the database user and passw (luciama2 - '12345', in my case)
+ after this, a UI for the admin of the db is shown


## Servicio adicional: FTP service

```
🧠 Que es FTP❓ FTP significa 'File Transfer Protocol' es un protocolo de redes para la transmision de archivos entre ordenadores a través de una conexión vía internet ('Transmission Control Protocol/Internet Protocol'). Las conexiones FTP tienen una relación de cliente y servidor. Esto quiere decir que un ordenador tiene que estar configurado como servidor FTP, ese en el que se aloja el contenido, y luego tú te conectas a él como un cliente. 
```

+ `sudo apt install proftpd`
+ `sudo adduser ftpuser`
+ By default, phMyAdmin runs on port 21, must allow the port on the uwf
	+ sudo ufw allow 21, this port only allows to connect to the client
+ In order for the server to connect and transmit files with the client, we must allow a range of ports for the data transmission
	+ `sudo vim /etc/proftpd/proftpd.conf` edit:
		+ line39, allow `DefaultRoot ~`
		+ line51, reset passive ports as `PassivePorts 49000 49010`
		+ line56, set `MasqueradeAddress` for the localhost IP `127.0.0.1`
+ The port range 49000:49010 must be added to the ufw: `sudo ufw allow 49000:4900/tcp`
+ `sudo systemctl restart proftpd`
+ After all this must add the port to the Networking section of out virtual machine on VirtualBox, me must add the 21 port and all ports for data transfer.
+ Then we can install on the client Filezila (the client) and connect to the server. The user we must add is the server user (in my case, luciama2 and the corresponding passw)