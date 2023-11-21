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
	+ edit file /etc/login.defs
		+ PASS_MAX_DAYS 99999 (line 165) -> PASS_MAX_DAYS 30
		+ PASS_MIN_DAYS 0 (line 166) -> PASS_MIN_DAYS 2
	+ Instalar los paquetes __
		+ sudo apt install libpam-pwquality
	+ Edit /etc/pam.d/common-password, adding after `retry=3`(line 25)
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

# Conectarse via SSH

+ Conectarse via SSH
	+ Cerrar la maquina virtual y en settings > network > advanced > port forwarding > add new port
		+ Rule 1 > Host Port: 4242, Guest Port: 4242
	+ To connect to the virtual machine we must write ssh luciama2@localhost -p 4242 (check the virtual machine is running)

//

# Script

´´´
🧠 Que es un script❓ Es una secuencia de comandos guardada en un fichero que cuando se ejecuta hara la funcion de cada comando.
´´´
1 - Architecture

Para poder ver la arquitectura del SO y su versión de kernel utilizamos el comando `uname -a` (flag -a equivale a --all) que basicamente printara toda la información excepto si el tipo de procesador es desconocido o la plataforma de hardware.

```
man uname
-- print operating system name
flags:
-a		behave as though all of the options -mnrsv were specified
-m      print the machine hardware name.
-n      print the nodename (the nodename may be a name that the system is known by to a communications network).
-p      print the machine processor architecture name.
-r      print the operating system release.
-s      print the operating system name (default behaviour).
-v      print the operating system version.
```

2 - Núcleos físicos

Para poder mostrar el número de núcleos físicos haremos uso del fichero `/proc/cpuinfo` el cual proporciona información acerca del procesador: su tipo, marca, modelo, rendimiento, etc. 

Usamos el comando `grep "physical id" /proc/cpuinfo | wc -l`, con `grep` buscaremos dentro del fichero "physical id" y con `wc -l` contamos las lineas del resultado de grep. Esto lo hacemos ya que la manera de cuantificar los nucleos no es mu commún: si hay un procesador marcará 0, si tiene más de 1, mostrará toda la información del procesador por separado contando los procesadores usando la notación cero. De esta manera simplemente contaremos las lineas que hay ya que es más cómodo cuantificarlo así.

```
man wc
-- word(-w), line(-l), character(-c) and byte(-c) count

man grep
-- file pattern searcher
```

3 - Núcleos virtuales

Parecido al anteior pero buscando en `processor` -> grep processor /proc/cpuinfo | wc -l

4 - Memoria RAM

Usamos el comando `free` para ver al momento la información sobre la ram, la parte usada, la libre, reservada para otros recursos, etc. Usamos `free --mega` para mostrar la información en megabytes, tal y como aparece en el subject.
La información nos la da como una tabla con la col1: tipo de memoria, col2: total (memoria total), col3: used, col4: free, col5: shared, col6: buff/cache, col7: available y en row1: Mem, row2: swap.

Para filtrar la busqueda de la información que necesitamos, usamos `awk` para comparar si la primera palabra de una fila es igual a "Mem:" printaremos la 3a palabra de esa fila, que será la memoria usada. Al final el comando será: `free --mega | awk '$1 == "Mem:" {print $3}'`

Como ultima parte debemos calcular el % de memoria usada. Usamos una operación (usada / total) printeando con printf dos decimales (%.2f) y el % al final (%%), entre paréntesis. El camando final sería: `free --mega | awk '$1 == "Mem:" {printf("(%.2f%%)\n", $3/$2*100)}'`

```
man awk
-- pattern-directed scanning and processing language
https://www.grymoire.com/Unix/Awk.html
```

5 - Memoria del disco

Para ver la memoria del disco ocupada y disponible utilizaremos el comando `df ` que significaa "disk filesystem" o "display free disk space", se usa para obtener un resumen completo del uso del espacio en disco. Como en el subject indica la memoria se muestra en MB, asi que usamos la flag `-m`. Este comando nos devuelve:
- en $1 el Filesystem
- en $2 1M-blocks
- $3, Used
- $4, Available
- $5, %Use
- $6, Mounted on

Para el subject necesitamos la memoria usada (la suma de todos los $3) y el espacio total ($2). Usamos `grep` para que solo nos muestre las líneas que contengan "/dev/" y otro grep para con el flag -v para excluir las lineas que contengan "/boot". Los comandos finales son:
+ `df -m | grep "/dev/" | grep -v "/boot" | awk '{memory_use += $3} END {print memory_use}'`
+ `df -m | grep "/dev/" | grep -v "/boot" | awk '{memory_result += $3} END {print memory_result}'`

Por útlimo, debemos mostrar el porcentaje de memoria usada. Usamos un comando muy parecido en donde pasamos un script a `awk` en el que declaramos el mem_use como $3, el mem_tot con el $2 y printeamos la operacion (mem_use/mem_tot)*100 entre paréntesis:
+ `df -m | grep "/dev/" | grep -v "/boot" | awk '{mem_use += $3} {mem_tot += $2} END {printf("(%d%%)\n", mem_use/mem_tot*100)}'`

6 - Porcentaje de uso de CPU

https://www.ibm.com/docs/es/aix/7.3?topic=usage-memory-determination-vmstat-command
https://www.ochobitshacenunbyte.com/2016/11/30/rendimiento-del-sistema-con-vmstat/

Para ver el porcentaje de uso de la CPU usamos el comando `wmstat`, visualizador de memoria virtualque, permitiendo obtener un detalle (una estadística) general de los procesos, uso de memoria, actividad de CPU, estado del sistema, etc. Se puede sin intervalo de tiempo, o con vmstat [intervalo [numero] ], siendo intervalo el periodo de tiempo entre actualizaciones, en segundos, y el numero, es el numero de actualizaciones, si no se da numero se supone infinito.

Análisis de la salida de wmstat en el apartado --cpu--
+ us	% de uso por usuario
+ sy	% de uso por usuario a nivel de sistema
+ id	% de tiempo que la CPU está desocupado -> usamos este, que es la palabra 15 de cada línea
+ wa	esperas de entrada y salida

Se usa además el comando `tail -1` para que nos de únicamente la última línea. El comando final es:
+ `vmstat 1 4 | tail -1 | awk '{print $15}'`

Para tener el número final, habría que resultarle a ese tiempo de 'CPU desocupada' la cantidad que nos ha (?) devuelto nuestro comando, el resultado de la operación lo printearemos con un decimal y un % al final.

7 - Último reinicio

Para ver la fecha y hora del último reinicio usamos el comando `who -b ` ya que nos mostrará el tiempo del último arranque del sistema. Para que nos muestre la información que necesitamos, usamos awk para filtrar que la primera palabra sea "system" y printeamos la fecha (la 3a y 4a palabras): `who -b | awk '$1 == "system" {print $3 " " $4}'`

```
man who -- display who is logged in
-a    	Same as -bdlprTtu.
-b    	Time of last system boot.
-d    	Print dead processes.
-H    	Write column headings above the regular output.
-l    	Print system login processes (unsupported).
-m    	Only print information about the current terminal.  This is the POSIX way of saying who am i.
-p    	Print active processes spawned by launchd(8) (unsupported).
-q    	``Quick mode'': List only the names and the number of users currently logged on.  When this option is used, all other options are ignored.
-r    	Print the current runlevel.  This is meaningless on Mac OS X.
-s    	List only the name, line and time fields.  This is the default.
-T    	Print a character after the user name indicating the state of the terminal line: `+' if the terminal is writable; `-' if it is not; and `?' if a bad line is encountered.
-t    	Print last system clock change (unsupported).
-u    	Print the idle time for each user, and the associated process ID.
am I  	Returns the invoker's real user name.
file  	By default, who gathers information from the file /var/run/utmpx.  An alternative file may be specified.
```

8 - Uso LVM

Para chequear si LVM (Logical Volume Manager) está activo o no se usa `lsblk`, que muestra la info de los dispositivos de bloque (discos duros, SSD, memorias, etc) y muestra el LVM en el tipo de gestor, nos da la informacion en un texto a modo de tabla con:
+ NAME 			nombre de los dispositivos
+ MAJ:MIN		numeros de dispositivo mayor y menor
+ RM			si el dispositivo es extraible
+ SIZE			tamaño del dispositivo
+ RO			si es solo de lectura
+ TYPE 			tipo de dispositivo -> nos da el lvm
+ MOUNTPOINTS	punto de montaje, si está disponible

Usamos grep, para filtrar las lineas en las que aparece 'lvm' y si hay mas de 0, printeamos Yes, si hay 0 printeara No: `if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi`

```
if CONDITION; then COMMAND; else COMMAND; fi
if [ $RESULT -gt 0 ]; then COMMAND; else COMMAND; fi

-gt		->		greater than
-lt		->		lower than
```

9 - Conexiones TCP

Para ver las conexiones TCP establecidad se usa el comando `ss -ta` que lista todas las conexiones TCP y filtramos la salida por aquellas que no solo sean de escucha (state = LISTEN) y contamos la cantidad con wc -l: `ss -ta | grep -v "LISTEN" | grep -v "State" | wc -l`

```
ss -- list all conexions
-a		all
-n  	Muestra los puertos en forma numérica.
-r		Intenta convertir a nombres las direcciones IP y los puertos. 
-e		Muestra información extra (temporizadores, inodo, uid, etc.)
-o		Muestra información de los temporizadores.
-p		Muestra el proceso que usa el socket.
-s		Muestra un resumen estadístico.
-4		Muestro sólo sockets IPv4.
-6		Muestra sólo sockets IPv6.
-t		Muestra sólo los sockets TCP.
-u		Muestra sólo los sockets UDP.
-s		Muestra un resumen estadístico.
```

```
Que es una conexion TCP -> Transfer Control Protocol, acuerdo estandarizado sobre el que se realizaa la transmisión de datos entre los participantes de una red informática.
Del lista de ss, sabemos cuales son TCP ya que en Local Address aparece la direcció IP.
```

10 - Número de usuarios

Se usa el comando `users` y se cuentan la cantidad de usuarios: `users | wc -l`

11 - Dirección IP y MAC

Se usa el comando `hostname -I` para la dirección del host, e `ip link` para obtener la MAC, filtrando con grep para filtrar lo que necesitamos: `ip link | grep "link/ether" | awk '{print $2}'`

12 - Numero de comandos ejecutados con sudo

Se usa el comando `journalctl _COMM=sudo` que recopila y administra los registros del sistema (Systemd) filtrando los entradas en su ruta (la de sudo). Después filtramos las lineas que contienen COMMAND y contamos las líneas: `journalctl _COMM=sudo | grep "COMMAND" | wc -l`

13 - Comando `wall` para printear el resultado

Por ultimo, para hacer el script, necesitaos guardar el resultado de cada comando en una variable y enviarlas a todos los usuarios que tengan una ventana de terminal abierta con el comando `wall` -- write all. Para enviar un mensaje de terminal a un unico usuario se usaría el comando `write`.