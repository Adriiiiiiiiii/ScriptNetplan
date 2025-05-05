
# ⚙️ Netplan Auto Config Script (IP fija + DHCP)

Este script Bash automatiza completamente la configuración de red en sistemas Linux basados en **Netplan**, asignando una interfaz como **externa (DHCP)** y otra como **interna (IP fija)**. Está pensado para servidores que funcionan como **gateways**, **routers** o **puntos de acceso** en redes locales.

---

## 📋 ¿Qué hace este script?

1. 🔍 **Detecta automáticamente las interfaces de red reales** (ignora loopback `lo`).
2. ❓ **Solicita al usuario**:
   - Una IP fija para la interfaz interna.
   - Una IP de servidor DNS.
3. 🧠 **Genera archivos de configuración Netplan**:
   - La primera interfaz se configura como DHCP (externa).
   - La segunda interfaz se configura con IP fija, DNS y una ruta por defecto.
4. 🧪 Ejecuta `netplan try` para validar la configuración.
5. 🚀 Aplica la configuración con `netplan apply`.
6. 💾 **Realiza backups automáticos** de los archivos `.yaml` modificados.
7. 📄 Muestra la configuración final por pantalla.

---

## ⚠️ Requisitos

- 🐧 Distribución basada en Ubuntu/Debian con Netplan (`Ubuntu 18.04+`, `Debian 10+`, etc.)
- 🔐 Permisos de `sudo`
- 🧑‍💻 Acceso a terminal interactiva (por los `read`)
- 🌐 Al menos **dos interfaces de red activas** (además de `lo`)

---

## 🧑‍💻 Uso

```bash
chmod +x netplan-auto-config.sh
sudo ./netplan-auto-config.sh
```

Durante la ejecución, se te pedirá:

- Una IP para la interfaz interna (ej. `192.168.50.1/24`)
- Un servidor DNS (puede ser `8.8.8.8` o una IP interna)

---

## 📝 Ejemplo de archivo generado (`/etc/netplan/*.yaml`)

```yaml
network:
  version: 2
  ethernets:
    enp0s3:
      dhcp4: true
    enp0s8:
      dhcp4: false
      addresses:
        - 192.168.50.1/24
      nameservers:
        addresses:
          - 8.8.8.8
      routes:
        - to: 0.0.0.0/0
          via: 192.168.50.1
```

---

## 🧯 Recuperación

En caso de problemas, puedes restaurar los archivos desde los backups generados automáticamente (`*.bak` en `/etc/netplan/`).

---

## 🟢 Resultado Final

Al terminar, verás la configuración actual de red aplicada y un mensaje de éxito:

```
✅ Configuración de red aplicada correctamente.
```

---
