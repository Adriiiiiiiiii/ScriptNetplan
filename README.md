# 🛠️ Netplan Auto Config Script

Este script automatiza completamente la configuración de red en sistemas basados en **Netplan (Ubuntu 18.04+, Debian, etc.)**, permitiendo que una interfaz se conecte por **DHCP (externa)** y otra funcione con una **IP fija (interna)**, actuando como servidor local o gateway.

---

## 📋 ¿Qué hace este script?

1. 🔍 **Detecta automáticamente las interfaces de red reales** (por ejemplo: `enp0s3`, `ens33`, etc.).
2. ❓ **Solicita al usuario:**
   - La IP fija para la interfaz interna.
   - El DNS a utilizar.
3. 🧠 **Genera archivos de configuración Netplan** para:
   - Asignar **DHCP** a la interfaz externa.
   - Asignar una **IP fija** a la interfaz interna con su DNS y ruta.
4. 🧪 Ejecuta `netplan try` para validar.
5. 🚀 Ejecuta `netplan apply` para aplicar.
6. 💾 **Realiza un backup** automático de los archivos `.yaml` modificados.

---

## ⚙️ Requisitos

- Distribución con Netplan (`Ubuntu 18.04+`, `Debian 10+`, etc.)
- Permisos de **sudo**
- Conexión a terminal interactiva (por los `read`)

---

## 🧑‍💻 Uso

```bash
chmod +x netplan-auto-config.sh
sudo ./netplan-auto-config.sh
