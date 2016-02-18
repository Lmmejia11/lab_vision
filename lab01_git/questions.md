# Warmup Questions

1.  What is the clone url of this repository?
    >   https://github.com/Lmmejia11/lab_vision

2.  What is the output of the ``cal`` command?

        El comando cal muestra un calendario del mes actual, 
	incluso con el día maseñalado:

	  Febrero 2016
	lu ma mi ju vi sa
	 1  2  3  4  5  6
	 8  9 10 11 12 13
	15 16 17 18 19 20
	22 23 24 25 26 27
	29

# Homework Questions

1.  What is the ``grep``command?
    >   grep "patron" [ARCHIVO]: busca lineas en el archivo ARCHIVO que contengran el patron. Se le pueden especificar muchas opciones, que determinan si el patron es una palabra, contenido dentro de una palabra, ignorar mayusculas, etc. Si no se espefifica un archivo, busca el standard-imput.

2.  What is a *makefile*?
    >   Makefiles son archivos con formatos especiales que, junto a la utilidad make, ayudan a crear y manejar proyectos. Estos archivos describe las relaciones entre archivos del programa, y le dice a make como crear el programa. Es especialmente uril para proyectos grandes y/o que tienen varios modulos.

4.  What does the ``-prune`` option of ``find`` do? Give an example
    >   La funcion find encuentra un diccionario dado un nombre. Cuando se agrega la opcion -prune, impide que find entre al directorio especificado. Es decir, encuentra el directorio, pero no reviza ningun archivo/directorio dentro de este. 
	Ejemplo: ~$ find images
	images
	images/sip-yar-gz
	images/bsds500.tar.gz
	~$ find images -prune
	images
    > Tambien puede ser utilizado para imprimir todos los archivos EXCEPTO el especificado
	Ejemplo: ~& find -path "./images" -prune -o -print,
	Imprime todos los archivos de "vision" excepto la carpeta images.

5.  Where is the ``grub.cfg``  file
    >   Usando ~$ find / -name "grub.cfg" 2>/dev/null: 
	/usr/share/doc/grub-common/examples/grub.cfg, y
	/boot/grub/grub.cfg


6.  How many files with ``gnu`` in its name are in ``/usr/src``
    >   ~$ find /usr/src -name gnu |wc -l: 0

7.  How many files contain the word ``gpl`` inside in ``/usr/src``
    >   ~$ grep -irm 1 gpl /usr/src | wc -l: 1550

8.  What does the ``cut`` command do?
    >   Se utiliza para procesamiento de texto. Te permite extraer porciones de un texto seleccionando columnas.

9.  What does the ``wget`` command do?
    >   Se utiliza para bajar archivos de internet y guardarlos en el directorio actual. Se necesita la direccion url del archivo a descargar.

9.  What does the ``rsync`` command do?
    >   Sirve para mantener dos copias de un archivo (en computadores diferentes) syncronizados (iguales). Tambien sirve para copiar archivos.

10.  What does the ``diff`` command do?
    >   Encuentra, linea a linea, las diferencias entre dos archivos

10.  What does the ``tail`` command do?
    >   Por default, imprime las ultimas 10 lineas de un archivo. Esta cantidad se puede cambiar.

10.  What does the ``tail -f`` command do?
    >   Imprime texto adicional a medida que el archivo crece

10.  What does the ``link`` command do?
    >   Crear un link a un archivo

11.  How many users exist in the course server?
    >   ~$ users | wc -w: 4

12. What command will produce a table of Users and Shells sorted by shell (tip: using ``cut`` and ``sort``)
    >   ~$ cut -d : -f 1,7 /etc/passwd | sort -t : -k2

13. What command will produce the number of users with shell ``/sbin/nologin`` (tip: using ``grep`` and ``wc``)
    >   ~$ /etc/passwd | cut -d: -f7 | grep /sbin/nologin| wc -l

15. Create a script for finding duplicate images based on their content (tip: hash or checksum)
    You may look in the internet for ideas, but please indicate the source of any code you use
    Save this script as ``find_duplicates.sh`` in this directory and commit your changes to github
    > Codigo obtenido de: http://www.tomshardware.com/forum/236826-50-linux-shell-script-find-duplicate-images

16. What is the meaning of ``#! /bin/bash`` at the start of scripts?
    >   Se le llama "sheband" y le indica con que programa debe interpretar el codigo. En este caso, el codigo se interpreta y corre por el bash shell.

17. How many unique images are in the ``sipi_images`` database?
    >   154 de textura, 38 aereas, 40 miscellanias, 69 de secuencia = 301 imagenes.
    
