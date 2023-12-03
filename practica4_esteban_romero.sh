#!/bin/bash

# usuario root
if [ "$EUID" -ne 0 ]; then
    echo "Este script debe ejecutarse como root. Finalizando."
    exit 1
fi
# archivo de entrada
archivo_paquetes="paquetes.txt"
# leer y cargarlo en un array
mapfile -t paquetes < "$archivo_paquetes"
# procesar paquetes
for paquete in "${paquetes[@]}"; do
    IFS=':' read -r nom_paquete accion <<< "$paquete"
    # accion desinstalar
    if [[ "$accion" == "remove" || "$accion" == "r" ]]; then
        # comprobar si esta instalado
        if whereis "$nom_paquete" | grep bin | wc -l | grep -q '0';then
            echo "$nom_paquete no esta instalado."
        else
            # desinstalar sin interaccion
            sudo apt remove -y "$nom_paquete"
            sudo apt purge -y "$nom_paquete"
            echo "Se ha desinstalado $nom_paquete."
        fi
    fi
    # accion instalar
    if [[ "$accion" == "install" || "$accion" == "i" ]];then
        # comprobar si no esta instalado
        if whereis "$nom_paquete" | grep bin | wc -l | grep -q '0';then
            # instalar sin interaccion
            sudo apt install -y "$nom_paquete"
            echo "Se ha instalado $nom_paquete."
        else
            echo "$nom_paquete ya esta intalado."
        fi
    fi
    # acción es status
    if [[ "$accion" == "status" || "$accion" == "s" ]];then
        # comprobar si esta instalado
        if whereis "$nom_paquete" | grep bin | wc -l | grep -q '0';then
            echo "$nom_paquete no instalado."
        else
            echo "$nom_paquete instalado."
        fi
    fi
done
exit 0