# Eval
https://github.com/gemartin99/Born2beroot-Tutorial#8--bonus-%EF%B8%8F

## General Instructions

+ During the defense, as soon as you need help to verify a point, the student evaluated must help you
+ Ensure that the `signature.txt` file is present at the root of the cloned repository
+ Check that the signature contained in the .txt is identical to that of the `.vdi` file of the virtual machine to be evaluated. A simple `diff`should allow you to compare two signatures. If necessary, ask the student being evaluated where their .vdi file is located.
	+ `diff -- compare files line by line -- diff [OPTION]... FILES`
+ As a precaution, you can duplicate the initial virtual machine in order to keep a copy.
+ Start the virtual machine to be evaluated.
+ If sth doesn't work as espected or the two signatures differ, the evaluation stops here.

***

## Mandatory part

The project consists of creating and configuring a virtual machine following strict rulless. The student being evaluated will have to help you during the defense. Make sure that all of the following points are observed.

***

### Project overview
```
+ The student being evaluated should explainn to you simply:
	+ How a virtual machine works
	+ Their choice of operating system.
	+ The asic differences between Rocky and Debian
	+ The purpose of virtual machines
	+ If the evaluated chose Rocky: what SELinux and DNF are
	+ If the evaluated student chose Debian: the difference between aptitude and apt, and what APPAmor is. During the defense, a script must display information all every 10 mins. Its operation will be checked in detail later. If the explanations are not clear, the evaluation stops here.
```
**¿Que es una maquina virtual❓**
```
Es un software que simula un sistema de computación y puede ejecutar programas como si fuese una computadora real. Permite crear múltiples entornos simulados o recursos dedicados desde un solo sistema de hardware físico.
```

**¿Por qué has escogido Debian❓**
```
Esto es algo personal para cada uno, mi opinion: El propio subject explica que es mas sencillo hacerlo en Debian y si buscas documentacion/tutoriales hay muchos y todos se han hecho en debian.
```
**Diferencias entre Rocky y Debian**
```
1. Origen:

Rocky Linux:
Rocky Linux es un sistema operativo de código abierto basado en Linux que se originó como un proyecto comunitario para proporcionar una alternativa a CentOS Linux. Fue creado por el creador original de CentOS, Gregory Kurtzer, con el objetivo de llenar el vacío dejado por los cambios en la dirección de CentOS.

Debian:
Debian es uno de los sistemas operativos Linux más antiguos y se desarrolla de forma comunitaria. Es conocido por su compromiso con la filosofía del software libre y su enfoque en la estabilidad.


2. Relación con otros Proyectos:

Rocky Linux:
Surge como una alternativa de código abierto después de que CentOS Linux cambió su modelo de desarrollo para centrarse en CentOS Stream, que es más orientado al desarrollo que a la estabilidad de servidor.

Debian:
Debian es la base para muchos sistemas operativos, incluidos Ubuntu y sus derivados. Ubuntu, por ejemplo, toma la rama de pruebas (testing) de Debian y le agrega su propia personalización.


3. Modelo de Lanzamiento:

Rocky Linux:
Sigue un modelo de lanzamiento basado en versiones estables, similar a CentOS Linux.

Debian:
Debian utiliza tres ramas principales: "Stable" (estable), "Testing" (pruebas), y "Unstable" (inestable). La versión estable es conocida por su enfoque en la estabilidad y suele tener lanzamientos menos frecuentes.


4. Gestión de Paquete
**Rocky es rhel/dnf. Debian es... Deb/apt.**

Rocky Linux:
Utiliza el sistema de gestión de paquetes "dnf" (Dandified YUM), que es una evolución de "yum". Dnf es usado en distribuciones basadas en Red Hat, como Fedora y CentOS.

Debian:
Utiliza el sistema de gestión de paquetes "dpkg" y el frontend "apt". Debian es conocido por su sistema de gestión de paquetes APT (Advanced Package Tool).


5. Ciclo de Vida del Soporte:

Rocky Linux:
Sigue un ciclo de vida de soporte similar al de CentOS Linux, con versiones de soporte a largo plazo (LTS).

Debian:
La versión "Stable" de Debian tiene un ciclo de vida de soporte a largo plazo y se centra en la estabilidad y la confiabilidad.
```

**¿Cual es el propósito de las VM?**
```
Su objetivo es el de proporcionar un entorno de ejecución independiente de la plataforma de hardware y del sistema operativo, que oculte los detalles de la plataforma subyacente y permita que un programa se ejecute siempre de la misma forma sobre cualquier plataforma.
```

**¿Qué es APPArmor❓**
```
Es un módulo de seguridad del kernel Linux que permite al administrador del sistema restringir las capacidades de un programa.
```

**¿Qué es LVM❓**
```
Logical Volume Manager. Es un gestor de volúmenes lógicos. Proporciona un método para asignar espacio en dispositivos de almacenamiento masivo, que es más flexible que los esquemas de particionado convencionales para almacenar volúmenes.
```

***

### Simple setup
```
+ Ensure that the machine does not have a graphical environment at launch. A password will be requested before attempting to connect to this machine. Finally, connect with a user with the help of the student being evaluated. This user must not be root. Pay attention to the password chosen, it must follow the rules imposed in the subject.
+ Check that the UFW service is started with the help of the evaluator
+ Check that the SSH service is started with the help of the evaluator.
+ Check that the chosen operating system is Debian or Rocky with the help of the evaluator. If something does not work as expected or is not clearly explained, the evaluator stops here.
```

```sh
# check no graphic interface is in use
ls /usr/bin/*session
# rslt: /usr/bin/dbus-run-session

# check ufw status
sudo ufw status
sudo service ufw status

# check kssh status
sudo service ssh status

# check OS
hostnamectl
uname -a
```
***

### User
```
The subject requests that a user with the login of the student being evaluated is present on the virtual machine. Check that it has been added and that it belongs to the `sudo` and `user42` groups.

Make sure the rules imposed in the subject concerning the password policy have been put in place by following the following steps.

First, ccreate a new user. Assign it a password of your choice, respecting the subject rules. The student being evaluated must now explain to you how they were able to set up the rules requested in the subject on their virtual machine.

Normally there should be one or two modified files. If there is any problem, the evaluation stops here.

+ Now that yyou have a new user, ask the student being evaluatd to create a group named `evaluating` in front of you and assign it to this user. Finally, check that this user belongs to the `evaluating` group.

+ Finally, ask the student beng evaluated to explain the advantages of this password policy, as wel as the advantages and disadvantages of its implementation. Of course, anwering that it is because the subject asks for it does not count.
```

```sh
# check groups to see if user is included
getent group sudo
getent group user42
cat /etc/group # check all groups
car /etc/sudoers # check permissions

# create new user & new group, then add user to group
sudo adduser name_user
sudo addgroup evaluating
sudo adduser name_user evaluating
#check it again
getent group evaluating

# explain pasww policy
cat /etc/pam.d/common-password
```
***

### Hostname and partitions
```
+ Check that the hostname of the machine is correctly formatted as follows: login42 (login of the student being evaluated)
+ Modify this hostname by replaing the login with yours, the restart the machine. If on restart, the hostname has not been updated, the eval stops here.
+ You can now resttore the machine to the original hostname
+ Ask the student being evaluated ho to view partitions for this virtual machine
+ Compare the output with the example given on the subject. Please note: if the student evaluated make the bonuses, it will necessary to refer to the bonuse example.

This part is an opportunity to discuss the scores! the student being evaluated should give a brief explanation on how LVM works and what it is all about.
```

```sh
#check hostname
hostname

# (1st option)
#modify hostname to replace former login to evaluator login
sudo nano /etc/hostname
sudo nano /etc/hosts
#or...
sudo vim /etc/hostname
sudo vim /etc/hosts
# reboot VM
# then check again
hostname 
# then restore hostname to the original hostname

# (2nd option)
#modify temporarily hostname
sudo hostname new_user42

# check partitions
lsblk
```

***

### SUDO
```
+ Check that the 'sudo' program is properly installed on the virtual machine
+ the student being evaluated should now show assigning you new user to the sudo group
+ The subject imposes strit rules for sudo. The student being evaluated must first explain the vaue and operation of sudo uding examples of their choice. In a second step, it must show you the imlementation of the rules imposed by the subject.
+ Verify that the '/var/log/sudo' folder exists and has at least one file. Check the contents of he filles in this folder, you should see a history of the commands used with sudo. Finally, try to run a command via sudo. See if the file(s) in the '/var/log/sudo/' folder have been updated.
```

```sh
which sudo
dpkg -s sudo

# add new user to sudo
sudo vim /etc/sudoers # sudo permissions
sudo adduser name_user sudo
getent group sudo

# show sudo rules
nano /etc/sudoers.d/sudo_config
#should show:
#	passwd_tries=3
#	baspass_message=
#	logfile="/var/log/config"
#	log_input, log_ouput
#	iolog_dir="/var/log/sudo"
#	requirrety
#	secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"

# show sudo command history
cd /var/log/sudo
ls
cat sudo_config | wc -l
#execute a sudo command and show it works
sudo echo hello4world
cat sudo_config | wc -l # +2  lines
```

***

### UFW/Firewall
```
+ Check that the "UFW" program is properly installed on the virtual machine.
+ Check that it is working properly.
+ The student being evaluated must be able to explain to you basically what SSH is and the value of using it.
+ Verify that the SSH service only uses port 4242
+ The student being evauated should help you use SSH in order to log in with the newly created user. To do this, you can se a key or a simple password. It will depend on the student being evaluated. Of course, you have to make sure that you cannot use SSH with the root user as stated in the subject. If something does not work as expected or ir not clearly explained, the evaluation stops here.
```
**Check ufw is installed**
```sh
dpkg -s ufw
sudo service ufw status

# check active rues
sudo ufw status numbered
# create rule
sudo ufw allow 8080
sudo ufw status numbered # it creates 2 rules
# delete rule
sudo ufw delete num_rule # we need to delete 2 rules
sudo ufw status numbered
```

***

### Script monitoring
```
The student should explain.
+ how their script works by showing you the code.
+ what 'cron' is
+ how the student being evaluated set up their script so that it runs every 10 minutes from when the server starts. Once the correct functioning of the script has been verified, the student being evaluated should ensure that this scripts runs every minute.. You can run whatever you want to make sure the script runs with dynamic values correctly. Finally, the student being evaluated should make the script stop running when the server has started up, but without modifying the script itself. To check this point, you will have to resstart the server one last time. At startup, it will be necessary to check that the script still exists in the same place, that its rights have remaind unchanged, and that it has not been modified.
```

```sh
which ssh
sudo service ssh status
# first check that with the root user we cannot,
ssh root@localhost -p 4242 #permission denied
ssh newuser@localhost -p 4242

# modify script to change exec time
sudo crontab -u root -e

# stop/start crontab
sudo /etc/init.d/cron stop
sudo /etc/init.d/cron start
```

***

## Bonus

### Bonus

+ Setting up partitions is worth 2 pts.
+ Setting up Wordpress only with the services required by the subject, is worth 2 pts.
+ The free choince service is worth 1pt. Verify and tet the proper functioning and iimplementation of each extra service. For the free choice service, the student being evaluated has to give you a simple explanation about how it works and why they think its useful. Please note that NGINX and Apache2 are prohibited.