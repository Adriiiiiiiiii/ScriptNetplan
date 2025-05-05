# ☁️ Nextcloud Auto Install Script (PHP 8.2 + MariaDB + NGINX)

Este script automatiza completamente la instalación de **Nextcloud** en servidores Linux con soporte para **PHP 8.2**, **MariaDB** y **NGINX**, ofreciendo una solución robusta y lista para producción.

---

## 📋 ¿Qué hace este script?

1. 🧹 **Elimina versiones antiguas de PHP** para evitar conflictos.
2. ⚙️ **Añade repositorios necesarios** y actualiza el sistema.
3. 🧰 **Instala dependencias clave**: PHP 8.2, MariaDB, NGINX, Certbot, etc.
4. 🛠️ **Configura MariaDB**:
   - Crea una base de datos y usuario específico para Nextcloud.
5. 📦 **Descarga y prepara Nextcloud** en `/var/www/nextcloud`.
6. 🔐 **Asigna permisos adecuados** a los archivos.
7. 🌐 **Configura NGINX** para servir Nextcloud.
8. 🔒 **Genera automáticamente un certificado SSL** con Let's Encrypt.
9. ⚙️ **Ajusta parámetros de PHP** para mejorar el rendimiento.
10. ⏲️ **Configura cron** para ejecutar tareas de mantenimiento.
11. ✅ Al final, proporciona instrucciones claras para completar la instalación vía navegador.

---

## ⚠️ Importante

Si la instalación de **MariaDB** falla durante la ejecución del script, puedes instalarla manualmente con:

\`\`\`bash
sudo apt update
sudo apt install mariadb-server
\`\`\`

Después, **vuelve a ejecutar el script**.

---

## ⚙️ Requisitos

- Sistema basado en Debian/Ubuntu con \`apt\`
- Permisos de **sudo**
- Acceso a la terminal interactiva
- Dominio configurado que apunte al servidor
- Puertos 80/443 accesibles para Certbot

---

## 🧑‍💻 Uso

\`\`\`bash
chmod +x nextcloud-install.sh
sudo ./nextcloud-install.sh
\`\`\`

---

## 🌐 Al finalizar

Accede a tu Nextcloud desde:  
\`https://<tu-dominio>\`

En la interfaz, usa los datos configurados en el script:

- **Base de datos**: el nombre introducido
- **Usuario**: el usuario creado
- **Contraseña**: la proporcionada
- **Servidor BBDD**: \`localhost\`

Si estás en red local, añade al archivo \`/etc/hosts\` del cliente:

\`\`\`
<IP-del-servidor>    <tu-dominio>
