#!/bin/bash

# Definición de Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m' # Reset

# Variables
NETPLAN_DIR="/etc/netplan"

# Título principal llamativo en morado
echo -e "${PURPLE}-------------------------------------------------${NC}"
echo -e "${PURPLE}🚀 Iniciando configuración automática de Netplan 🚀${NC}"
echo -e "${PURPLE}-------------------------------------------------${NC}"

# Detectar interfaces de red (ignorando loopback lo)
echo -e "${YELLOW}🔍 Detectando interfaces de red disponibles...${NC}"
interfaces=($(ls /sys/class/net | grep -v lo))

# Verificar que haya al menos dos interfaces
if [ ${#interfaces[@]} -lt 2 ]; then
  echo -e "${RED}❌ No se detectaron suficientes interfaces de red. Se requieren al menos 2.${NC}"
  exit 1
fi

# Asignar interfaces detectadas
NET_INTERFACE="${interfaces[0]}"
INT_INTERFACE="${interfaces[1]}"

echo -e "${GREEN}✅ Interfaz para red externa (DHCP): $NET_INTERFACE${NC}"
echo -e "${GREEN}✅ Interfaz para red interna (IP fija): $INT_INTERFACE${NC}"

# Preguntar IP para la interfaz interna
read -p "$(echo -e ${YELLOW}👉 Introduce la IP que quieres para la interfaz interna \($INT_INTERFACE\) \(ej: 192.168.50.1/24\): ${NC})" IP_INTERNA

if [[ -z "$IP_INTERNA" ]]; then
  echo -e "${RED}❌ IP no válida. Abortando.${NC}"
  exit 1
fi

# Preguntar DNS a usar
read -p "$(echo -e ${YELLOW}👉 Introduce la IP del DNS que quieres usar \(ej: 8.8.8.8 o tu propia IP\): ${NC})" DNS_SERVER

if [[ -z "$DNS_SERVER" ]]; then
  echo -e "${RED}❌ DNS no válido. Abortando.${NC}"
  exit 1
fi

# Paso 1: Configurar archivos
echo -e "${YELLOW}🛠️ Configurando archivos de Netplan en $NETPLAN_DIR...${NC}"
for file in $NETPLAN_DIR/*.yaml; do
  if sudo tee "$file" > /dev/null <<EOF
network:
  version: 2
  ethernets:
    $NET_INTERFACE:
      dhcp4: true
    $INT_INTERFACE:
      dhcp4: false
      addresses:
        - $IP_INTERNA
      nameservers:
        addresses:
          - $DNS_SERVER
      routes:
        - to: 0.0.0.0/0
          via: ${IP_INTERNA%/*}
EOF
  then
    echo -e "${GREEN}✅ Archivo $file configurado correctamente.${NC}"
  else
    echo -e "${RED}❌ Error al configurar $file.${NC}"
    exit 1
  fi
done

# Paso 2: Probar Netplan
echo -e "${YELLOW}🧪 Ejecutando 'netplan try'...${NC}"
if sudo netplan try; then
  echo -e "${GREEN}✅ netplan try exitoso.${NC}"
else
  echo -e "${RED}❌ Error en 'netplan try'. Puede ser necesario revisar la configuración.${NC}"
  exit 1
fi

# Paso 3: Aplicar Netplan
echo -e "${YELLOW}🚀 Aplicando configuración con 'netplan apply'...${NC}"
if sudo netplan apply; then
  echo -e "${GREEN}✅ Configuración de red aplicada correctamente.${NC}"
else
  echo -e "${RED}❌ Error aplicando 'netplan apply'.${NC}"
  exit 1
fi

# Paso 4: Hacer backup de los archivos modificados
echo -e "${YELLOW}📦 Realizando backup de los archivos Netplan modificados...${NC}"
for file in $NETPLAN_DIR/*.yaml; do
  if sudo cp "$file" "${file}.bak"; then
    echo -e "${GREEN}✅ Backup de $file realizado como ${file}.bak.${NC}"
  else
    echo -e "${RED}❌ Error al hacer backup de $file.${NC}"
    exit 1
  fi
done

# Mostrar configuración final
echo -e "${BLUE}📄 Configuración actual de Netplan:${NC}"
sudo cat $NETPLAN_DIR/*.yaml

# Finalización
echo -e "${PURPLE}-------------------------------------------------${NC}"
echo -e "${GREEN}✅ Script de configuración finalizado con éxito.${NC}"
echo -e "${PURPLE}-------------------------------------------------${NC}"
