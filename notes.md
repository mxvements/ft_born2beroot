# Debian installation

* Language: English
* Territory: Other
* Location > Continent or region: Europe
* Locarion > Country, territory or area: Spain
* Country to base default locale settings on: USA
* Keymap to use: Spanish

/

* Host name for the system: luciama242
* Domain name: (blank)
* Root password: Hola42-madrid

/

* User account name: luciama2
* User password: Hola42-telefonica

/

* Partition disks, partitioning method: Manual (for the bonus)
	* Dispositivo donde creo las particiones: SCSI2 (sda)
	* sda1 ->
		* type: primary, because its a boot partition
		* Location: Beginning
		* Size: 500m
		* Mount point: /boot
	* sda5 ->
		* type: logical
		* Size: max
		* Mount point: do not mount it

```
Descripción breve de todos los tipos de particiones:

◦ Primaria: La única partición en la que puede estar instalada un SO. Solo pueden haber 4 particiones primarias por disco duro o 3 primarias y una extendida.

◦ Secundario/Extendida: Fue ideada para romper la limitación de 4 particiones primarias en un solo disco físico. Solo puede existir una partición de este tipo por disco, y solo sirve para contener particiones lógicas.

◦ Lógica: Ocupa una porción de la partición extendida/primaria o la totalidad de la misma, la cual se ha formateado con un tipo específico de sistema de archivos (en nuestro caso usaremos ext4) y se le ha asignado una unidad, así el sistema operativo reconoce las particiones lógicas o su sistema de archivos. Puede haber un máximo de 23 particiones lógicas en una partición extendida , sin embargo linux el SO con el que trabajamos actualmente lo reduce a 15, más que suficientes para realizar este proyecto.
```

* Configure encrypted volumes -> /dev/sda5
	* Encryption passphrase: Hello42-madrid
* Configure the Logical Volume Manager  (LVM) -> Create volume group -> LVMGroup in dev/mapper/sda5_crypt
	+ We do this to create all logical partitions specified on the subject, we need to *create a logical volume* for:
		+ root, 10G, Use as ext4, Mount point: /
		+ swap, 2.3G, Use as swap area
		+ home, 5G, Use as ext4, Mount point: /home
		+ var, 3G, Use as ext4, Mount point: /var
		+ srv, 3G, Use as ext4, Mount point: /srv
		+ tmp, 3G, Use as ext4, Mount point: /tmp
		+ var-log, 4G, Use as ext4, Mount point: (manually) /var/log

/

+ Configure the package manager, w/o any additional software and w/o the package usage survey
+ Install GRUB boot on /dev/sda

//

+ Install sudo
	+ 1st, change to root user: 
		+ su + passw
	+ apt install sudo
	+ sudo -V
+ Add user
	+ sudo adduser login -> sudo adduser luciama2 (which already exists)
+ Create group
	+ sudo addgroup user42
	+ Check group:
		+ getent group user42
		+ cat /etc/group
//

+ Instalacion de ssh
	+ sudo apt update
	+ Install OpenSSH
		+ sudo apt install openssh-server
	+ Check install
		+ sudo service ssh status
```
🧠 Que es SSH❓ Es el nombre de un protocolo y del programa que lo implementa cuya principal función es el acceso remoto a un servidor por medio de un canal seguro en el que toda la información está cifrada.
```
+ Installing vim
	+ apt update
	+ apt install vim
+ Tras la instalacion de ssh, se editarán algunos ficheros de configuración (con nano o vim)
	+ sudo nano /etc/ssh/ssh_config
	+ reiniciar el servicio ssh para que se actualicen las modificaciones
		+ sudo service ssh restart
		+ sudo service ssh status (check)

//

+ Instalacion y configuracion UFW
	+ sudo apt install ufw
	+ sudo ufw enable (check if it's enabled)
	+ sudo ufw allow 4242
	+ sudo ufw status
```
🧠 Que es UFW❓ Es un firewall el cual utiliza la línea de comandos para configurar las iptables usando un pequeño número de comandos simples.
```
+ Configurar contraseña fuerte para sudo
	+ crear fichero /etc/sudoers.d/ que se llamara sudo_config
	+ touch  /etc/sudoers.d/sudo_config
	+ Crear el directorio sudo en la ruta `var/log`porque cada comando que ejecutemos con sudo, tanto el input como el output, debe quedar almacenado en ese directorio
		+ mkdir /var/log/sudo
	+ Editar el fichero creado en el punto anterior para introducir los comando que pide el subject
		+ vim /etc/sudoers.d/sudo_config
			+ Defaults passwd_tries=3
				+ numero de intentos en caso de introducir una constraseña incorrecta
			+ Defaults badpass_message="Message"
				+ Mensaje que se mostrará por pantall en caso de que la contraseña introducida sea incorrecta
			+ Defaults lofgile="/var/log/sudo/sudo_config"
				+ Archivo en el que quedarán registrados todos los comandos sudo
			+ Defaults log_input, log_ouput
				+ Para que cada comando ejecutado quede registrado en el directorio especificado, tanto los inputs como los ouputs
			+ Defaults iolo_dir="/var/log/sudo"
			+ Defaults requiretty
				+ Para activar el modo TTY
			+ Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
+ Configuración de política de constraseña fuerte
	




