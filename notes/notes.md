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
NOTES ON PARTITIONS

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


```
NOTES ON LINUX DIRECTORY
/bin:
Stands for "binary."
Contains essential command binaries (executable files) that are required for the system to function, and are needed for system recovery.
/boot:
Contains the kernel and initial ramdisk (initrd) used during the boot process.
Files like vmlinuz (kernel) and initrd.img are often found here.
/dev:
Stands for "device."
Contains device files representing hardware devices on the system.
/etc:
Stands for "editable text configuration."
Contains system-wide configuration files and shell scripts used to boot the system and configure services.
/home:
Home directories for regular users are typically located here.
/lib:
Contains essential shared libraries needed by system programs.
/lib32 and /lib64:
On some systems, these directories may contain 32-bit and 64-bit libraries, respectively, to support applications running in different architectures.
/lost+found:
Used by the filesystem check (fsck) tool to recover files and directories that may have been partially recovered after a system crash.
/media:
Mount point for removable media such as USB drives.
/mnt:
Historically used as a mount point for temporary filesystems or additional storage devices.
/opt:
Stands for "optional."
Used for installation of additional software packages not included in the default installation.
/proc:
Stands for "process."
A virtual filesystem that provides information about processes and kernel parameters.
/root:
Home directory for the root user.
/run:
A tmpfs (temporary filesystem) holding runtime information.
/sbin:
Stands for "system binary."
Contains essential system binaries that are mostly used by the system administrator for system maintenance.
/srv:
Stands for "service."
Contains site-specific data served by this system, such as data and scripts for web servers.
/sys:
A virtual filesystem that exposes information about devices and kernel parameters, similar to /proc.
/tmp:
Stands for "temporary."
A directory for temporary files that are often deleted upon reboot.
/usr:
Stands for "Unix System Resources."
Contains a variety of user-related programs, libraries, documentation, and source code.
/var:
Stands for "variable."
Contains variable data, such as logs, spool files, and temporary files.
/vmlinuz:
The Linux kernel executable.
/initrd.img:
The initial ramdisk used by the kernel during the boot process.
/initrd.img.old and /vmlinuz.old:
Backup copies of previous kernel and initrd files.
```

+ Configure the package manager, w/o any additional software and w/o the package usage survey
+ Install GRUB boot on `/dev/sda`

# Installing things on VM

## SUDO

+ Install sudo
	+ 1st, change to root user: 
		+ su + passw
	+ `apt install sudo`
	+ `sudo -V`
+ Add user
	+ `sudo adduser login` -> sudo adduser luciama2 (which already exists)
+ Create group
	+ `sudo addgroup user42`
	+ Check group:
		+ `getent group user42`
		+ `cat /etc/group`

## SSH
```
🧠 Que es SSH❓ Es el nombre de un protocolo y del programa que lo implementa cuya principal función es el acceso remoto a un servidor por medio de un canal seguro en el que toda la información está cifrada.
```
+ Instalacion de ssh
	+ `sudo apt update`
	+ Install OpenSSH
		+ `sudo apt install openssh-server`
	+ Check install
		+ `sudo service ssh status`

## VIM
+ Installing vim
	+ apt update
	+ apt install vim
+ Tras la instalacion de ssh, se editarán algunos ficheros de configuración (con nano o vim)
	+ sudo nano /etc/ssh/ssh_config
	+ reiniciar el servicio ssh para que se actualicen las modificaciones
		+ sudo service ssh restart
		+ sudo service ssh status (check)

# UFW (firewall)

```
🧠 Que es UFW❓ Es un firewall el cual utiliza la línea de comandos para configurar las iptables usando un pequeño número de comandos simples.
```

+ Instalacion y configuracion UFW
	+ sudo apt install ufw
	+ sudo ufw enable (check if it's enabled)
	+ sudo ufw allow 4242
	+ sudo ufw status
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

## Strong password policy

+ Configuración de política de constraseña fuerte
	+ edit file `/etc/login.defs`
		+ PASS_MAX_DAYS 99999 (line 165) -> PASS_MAX_DAYS 30
		+ PASS_MIN_DAYS 0 (line 166) -> PASS_MIN_DAYS 2
	+ Instalar los paquetes __
		+ sudo apt install libpam-pwquality
	+ Edit `/etc/pam.d/common-password`, adding after `retry=3`(line 25)
		+ minlen=10
		+ ucredit=-1
		+ dcredit=-1
		+ lcredit=-1
		+ maxrepeat=3
		+ reject_username
		+ difok=7
		+ enforce_for_root


```
NOTES ON /etc/login.defs
- PASS_MAX_DAYS: Es el tiempo de expiración de la contraseña. El numero corresponde a días.
- PASS_MIN_DAYS: El número mínimo de días permitido antes de modificar una contraseña.
- PASS_WARN_AGE: El usuario recibira un mensaje de aviso indicando que faltan los dias especificados para que expire su contraseña.
```	

```
NOTES ON /etc/pam.d/common_password
- minlen=10 ➤ La cantidad minima de caracteres que debe contener la contraseña.
 ucredit=-1 ➤ Como mínimo debe contener una letra mayúscula. Ponemos el - ya que debe contener como mínimo un caracter, si ponemos + nos referimos a como maximo esos caracteres.
- dcredit=-1 ➤ Como mínimo debe contener un digito.
- lcredit=-1 ➤ Como mínimo debe contener una letra minúscula.
- maxrepeat=3 ➤ No puede tener más de 3 veces seguidas el mismo caracter.
- reject_username ➤ No puede contener el nombre del usuario.
- difok=7 ➤ Debe tener al menos 7 caracteres que no sean parte de la antigua contraseña.
- enforce_for_root ➤ Implementaremos esta política para el usuario root.
```

## Crontab

```
🧠 Que es crontab? Es un administrador de procesos en segundo plano. Los procesos indicados seran ejecutados en el momento que especifiques en el fichero crontab.
```

+ Para tener Crontab configurado debemos editar el fichero con el comando `sudo crontab -u root -e`. Root user no tendrá crontab, creará uno nuevo. Habrá que añadir el comando `*/10 * * * * sh /ruta del script` -> `*/10 * * * * sh /home/luciama2/monitoring.sh`

# Conectarse via SSH

+ Conectarse via SSH
	+ Cerrar la maquina virtual y en settings > network > advanced > port forwarding > add new port
		+ Rule 1 > Host Port: 4242, Guest Port: 4242
	+ To connect to the virtual machine we must write ssh luciama2@localhost -p 4242 (check the virtual machine is running)

```
sudo crontab --help
crontab [-u user] [-n] file
-h			displays help
file 		
-n			checks the syntax, then bails out
-u user		choose the user whose cronta is touched
-e			edit user's crontab
-l			list user's crontab
-r			delete user's crontab
-i			prompt before deleting user's crontab
```


# Signature.txt

Este archivo es el que se envía al repositorio de la vogsphere.