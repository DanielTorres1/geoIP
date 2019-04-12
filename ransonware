#GESTION DE INCIDENTES DE RANSOMWARE

## COORDINACION CON EL RSI
Solicitar al RSI que desconecte la red (cableada y Wi-Fi) y cualquier dispositivo de almacenamiento externo
Solicitar al RSI los logs del proxy/firewall del dia de la infeccion


## TRABAJO EN SITIO

Realizar copia de memoria RAM del equipo infectado (Usar FTK portable)


INTENTAR RECUPERAR "SHADOW COPY"
Listar si existen "shadow copies"
    vssadmin list shadows
    En caso que hubiera copias, usar ShadowExplorer.exe (portable) para recuperar archivos

DETERMINAR LA FORMA DE INFECCION

Informacion basica del sistema
systeminfo

informacion de red
ipconfig /all

Identificar con que equipos se comunico
arp -a

Extraer el historial de navegacion (Ejecutar como el usuario que infecto el equipo)
    Chrome History View (AGAVE)
    Mozilla History View (AGAVE)
    IE History View (AGAVE)

Registro de actividades (Necesita permisos de administrador)
    LastActivityView 
    MyEventViewer
    RecentFileView
    USBDBView

Nota: Transformar los archivos a UTF-8 con el comando dos2unix


## ANÁLISIS FORENSE

Realizar el apagado brusco del equipo. Desconectar el cable (PC de escritorio), Usar el boton de apagado (Laptop)
Realizar copia bit a bit del disco duro
   dd if=/dev/sdc of=/media/parrot/disk600Gb/backup.img bs=64M conv=sync,noerror status=progress
   
   Si fuera necesario convertir la imagen forense en disco virtual
   qemu-img convert -O vmdk -o compat6 backup.img vmdkname.vmdk
   qemu-img convert -f raw -O vmdk rawdisk200gb.img vdisk200gb.vmdk   


Identificar exactamente que variante de ransomware infecto al host
    https://id-ransomware.malwarehunterteam.com/index.php
    https://www.nomoreransom.org/crypto-sheriff.php?lang=en
    Buscar IoC (IPs, dominios, etc) en los logs del firewall/proxy

Identificar si el ransomware usa llave simetrica (AES) o asimetrica (RSA). Si el ransomware usa una llave simetrica buscar la llave de encriptación en la copia de la memoria RAM.   



##BUSCAR HERRAMIENTAS PARA DESINCRIPTAR
https://docs.google.com/spreadsheets/d/1TWS238xacAto-fLKh1n5uTsdijWdCEsGIM0Y0Hvmc5g/pub?output=html
https://heimdalsecurity.com/blog/ransomware-decryption-tools/
https://www.nomoreransom.org/en/decryption-tools.html
https://www.avast.com/ransomware-decryption-tools
https://decrypter.emsisoft.com/
https://support.kaspersky.com/viruses/utility
https://noransom.kaspersky.com/?tool=.[EXTENSION ARCHIVOS CIFRADOS]
https://malpedia.caad.fkie.fraunhofer.de/

## INTENTAR RECUPERAR ARCHIVOS DE LA COPIA FORENSE:
- Usar Autopsy con la copia forense
- Usar FTK para montar la imagen forense y usar el software de recuperacion "recuva"


## ANEXOS

Links de descarga:
    https://www.shadowexplorer.com/downloads.html
    http://devcdn.avanquest.com/rw/WindowsDataRecovery.exe


Extracción de llave de cifrada estático (AES) de memoria RAM
    https://medium.com/@0xINT3/jigsaw-ransomware-analysis-using-volatility-2047fc3d9be9

Posibles vectores:
- pop-ups
- facebook messenger
- mail  
- Cracks

