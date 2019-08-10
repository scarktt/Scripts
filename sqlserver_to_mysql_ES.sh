#!/bin/bash
# ---------------------------------------------------------------------------------------------
# DESCRIPCION:    El script realiza la conversión a SQL (con sintaxis MYSQL) de
#                 un archivo script SQL generado de forma automática por el
#                 software Case Studio con una sintaxis de original de SQLServer.
#
# ---------------------------------------------------------------------------------------------
# EJECUCION DEL SCRIPT:	El primer parametro que se debe de escribir corresponde
#					              al nombre del script generado por el Case Studio.
#
#                       La sintaxis para utilizar el script es la siguiente:
#                       ./scriptsqlserver_to_scriptmysql.sh Nombrescript.sql
#
#                       * Se asume que dicho archivo generado por Case Studio
#                         se encuentra en la misma ubicación del archivo. De no
#                         ser así escribir la ruta completa al archivo.

# Se reemplaza el primer corchete por un espacio vacío
sed 's/\[//g' ./$1 > ./script.sql
# Se reemplaza el segundo corchete por un espacio vacío
sed -i '' 's/\]//g' ./script.sql
# Se reemplaza la palabra reservada go por un espacio vacío
sed -i '' 's/go//g' ./script.sql
# Se reemplaza la palabra reservada Money por un decimal de longitud 13
# y 3 decimales -Cambiar esto a gusto personal.
sed -i '' 's/Money/Decimal (13,3)/g' ./script.sql
# Se reemplazan todos los paréntesis que estén al inicio por );
awk '{ gsub(/^\)/,");"); print }' ./script.sql > scriptMySQL.sql
# Se eliminan los Set quoted_identifier
sed -i '' '/Set quoted_identifier/d' ./scriptMySQL.sql

# Se eliminar el script que fue generado temporalmente
rm ./script.sql

# Se verifica si existe el editor atom instalado en el SO para abrir ahí el
# el nuevo script sql con sintaxis mysql, si no existe se abre en el editor nano.
if which atom >/dev/null; then
    atom scriptMySQL.sql
else
    nano scriptMySQL.sql
fi
