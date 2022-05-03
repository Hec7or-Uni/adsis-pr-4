# Práctica 4
**Autores:**
<br>**`Héctor Toral Pallás`**
<br>**`Francisco Javier Pizarro Martinez`** <br>
**Fecha: `20-04-2022`** <br>
**Grupo: `Miércoles-B 10-12am`**

---

## Primeros pasos

### Red Virtual 
```
vBox: Archivo > administrador de red anfitrión
```

![red virtual](https://github.com/Hec7or-Uni/adsis-pr-4/blob/main/assets/redVirtual.jpg)

### Maquinas

- Cliente:
  - debian_host
- Servidor:
  - debian_as1
  - debian_as2

La maquina **cliente** tendrá **2 adaptadores** de red, 1 tipo NAT y otro con la red virtual creada en el paso anterior.<br>
Las maquinas **servidor** solo dispondrán de **1 adaptador** que será el de la red virtual creada en el paso anterior.

### Sudo

Modifica el fichero `sudoers` para que el usuario `as` pueda usar sudo sin contraseña.
```sh
as@as:~$ sudo nano /etc/sudoers
```
Actualiza el fichero añadiendo la linea siguiente:
```
as ALL=(ALL) NOPASSWD:ALL
```

## Configuración de red
Dentro de las maquinas **servidor** se debe cambiar el contenido del fichero `/etc/network/interfaces` para establecer una configuración especifica para las maquinas de tal manera que se permita la comunicación entre ambas.

```sh
as@as:~$ sudo nano /etc/network/interfaces
```

```
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# --------------------------------------------------
# The primary network interface
auto enp0s3 
iface enp0s3 inet static 
  address 192.168.56.X
  netmask 255.255.255.0
# --------------------------------------------------
```

La X deberá ser sustituida por 11 (debian_as1) u 12 (debian_as2) para pasar los **test** de la práctica. <br>
No tienen por que ser esos números pero si que tienen que ser distintos entre si, además no deben ser ni 1 ni 0.

Una vez actualizado el fichero de configuración de red reinicia el servicio con el siguiente comando para que se vean los cambios.

```sh
as@as:~$ sudo systemctl restart networking
```

Puedes comprobar que la configuración se ha realizado correctamente haciendo un ping a la otra maquina.

Para la maquina cliente:
```
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug enp0s8
iface enp0s8 inet dhcp

# --------------------------------------------------
auto enp0s3 
iface enp0s3 inet static 
  address 192.168.56.2
  netmask 255.255.255.0
# --------------------------------------------------
```

## Configuración de acceso

#### Cliente

Para poder conectarte a los servidores se deberá generar una clave de acceso mediante el siguiente comando:

```sh
as@as:~$ ssh-keygen -b 4096 -t ed25519
```

Si se quiere que pase los **test** se deberá renombrar los ficheros de la siguiente forma: `id_as_ed25519` <br>
Se enviará la clave pública del cliente a los servidores para poder acceder a ellos mediante ssh.
```sh
scp .ssh/id_as_ed25519.pub as@192.168.56.11:~/ 
scp .ssh/id_as_ed25519.pub as@192.168.56.12:~/
```

#### Servidores

Se crearán los ficheros donde será copiada la clave pública del cliente en ambas maquinas (debian_as1 y debian_as2) mediante:

```sh
as@as:~$ touch .ssh/authorized_keys
```

Una vez con el archivo creado y las claves públicas en las maquinas servidor, añadiremos las claves al archivo: `.ssh/authorized_keys` mediante por ejemplo el siguiente comando:

```
as@as:~$ cat id_as_ed25519.pub >> .ssh/authorized_keys
```

### Configuración ssh

Modifica el fichero de configuración ssh para impedir conexiones como root además, el resto de conexiones que se realicen no se requerira de la autenticación de contraseña.
```sh
as@as:~$ sudo nano /etc/ssh/sshd_config
```

cambia del fichero `sshd_config` la configuración para que quede similar a lo siguiente:
```
...
# PermitRootLogin prohibit-password
PermitRootLogin no
...
# PasswordAuthentication yes
PasswordAuthentication no
...
```

Una vez realizados los cambios reinicia el servicio
```sh
as@as:~$ sudo systemctl reload ssh
```
