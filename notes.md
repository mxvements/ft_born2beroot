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


