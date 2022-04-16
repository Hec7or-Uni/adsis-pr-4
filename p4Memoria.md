# Práctica 4
## Configuración básica
Realizamos la configuración previa en virtual box como indica el guión de la práctica(dos mv conectadas a la red interna del host y una tercera conectada a la red NAT), después modificamos el archivo de sudoers mediante
> sudo vi /etc/sudoers

<br>
Añadimos esta linea al final del fichero

> as ALL=(ALL) NOPASSWD:ALL

<br>
Guardamos mediante

> esc + :wq!

## Configuración de red
Para las maquinas as1 y as2

> sudo vi /etc/network/interfaces

<br>
Borramos todo lo que hay debajo de la linea de source y escribimos

> auto enp0s3
  iface enp0s3 inet static
    address 192.168.56.X
    netmask 255.255.255.0
<br>

X se sustituye por 2 en el caso de as1 y por 3 en caso de as2<br>
Guardamos mediante

> esc + :wq

## Autentificación
### Claves
En host ejecutamos el siguiente comando para generar la clave

> ssh-keygen -b 4096 -t ed25519 

<br>
Nos solicitara un directorio y pulsaremos enter para dejar el default, nos solicitara una frase para cifrar y pulsaremos enter dos veces.

### Preparar servidores
En as1 y as2

> cd .ssh
  touch authorized_keys
  
<br>

### Preparar cliente
En host

> cd .ssh
  scp id_ed25519.pub as@192.168.56.2:~/
  scp id_ed25519.pub as@192.168.56.3:~/

### Añadir las claves a las permitidas en servidores
En as1 y as2
> cd
  cat id_ed25519.pub >> .ssh/authorized_keys

## Configuración de ssh
> sudo vi /etc/ssh/sshd_config

<br>
Buscamos la linea que pone PermitRootLogin y la descomentamos, sustituimos lo que hay al final de la linea por un no
Buscamos la linea que pone PasswordAuthentication la descomentamos y sustituimos lo que hay al final por un no
Guardamos mediante

> esc + :wq

<br>
Para reiniciar el servicio y que tengan lugar los cambios que hemos realizado en la configuración

> systemctl reload ssh
