# 02 — VS Code

> **Visual Studio Code** es el editor de código principal del proyecto. Es gratis, multiplataforma y altamente extensible.

---

## 🎯 ¿Por qué VS Code?

- **Gratis y open source**
- **Multiplataforma** (Mac, Linux, Windows)
- **Extensiones para todo:** PlatformIO, Wokwi, Git, Markdown, etc.
- **Terminal integrada** — no necesitas alternar ventanas
- **Estándar de la industria** — saberlo usar te sirve en cualquier trabajo de programación

---

## 📥 Instalación

### macOS

#### Opción 1: Descarga directa (recomendado)

1. Abre el navegador y ve a: **https://code.visualstudio.com**
2. Click en **"Download Mac Universal"** (funciona en Intel y Apple Silicon)
3. Se descarga un archivo `.zip`
4. Doble click al `.zip` para extraerlo
5. Aparece **"Visual Studio Code.app"**
6. **Arrástralo a la carpeta `Applications`**
7. Listo

#### Opción 2: Homebrew (si lo usas)

```bash
brew install --cask visual-studio-code
```

### Linux

```bash
# Ubuntu/Debian
sudo snap install code --classic

# Fedora
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo dnf install code
```

### Windows

1. Ve a https://code.visualstudio.com
2. Descarga el instalador `.exe`
3. Ejecuta y sigue el asistente
4. Marca **"Add to PATH"** durante la instalación

---

## 🚀 Primer arranque

1. Abre VS Code desde Launchpad (Mac) o el menú de aplicaciones
2. La primera vez aparece la pantalla de bienvenida con opciones para:
   - Cambiar tema (claro/oscuro)
   - Configurar atajos de teclado
   - Instalar extensiones

Puedes saltar todo esto por ahora.

---

## 🧩 Extensiones requeridas para el proyecto

Las extensiones son "plugins" que agregan funcionalidad. Las que necesitamos:

### 1. PlatformIO IDE (esencial)

**Para qué:** Compilar y subir código al ESP32.

**Cómo instalar:**
1. Click en el ícono de extensiones (panel izquierdo): cuadritos apilados, o `Cmd + Shift + X`
2. En la barra de búsqueda escribe: `PlatformIO IDE`
3. Click en **"Install"** sobre la extensión oficial de PlatformIO
4. ⏳ Espera 3-5 minutos (es grande, descarga muchas herramientas)
5. Cuando termine, VS Code te pedirá **reiniciar** — acepta
6. Al reabrir, verás un ícono de "carita de alien" 👽 en la barra lateral

### 2. Wokwi Simulator (opcional)

**Para qué:** Simular el ESP32 directamente en VS Code.

**Cómo instalar:**
1. En extensiones, busca: `Wokwi`
2. Instala **"Wokwi Simulator"** del autor "Wokwi"
3. Después de instalar, sigue los pasos en la [Guía de Wokwi](04-wokwi.md) para activar la licencia gratuita

⚠️ **Nota:** Esta extensión a veces tiene bugs en Mac. La alternativa es usar [wokwi.com](https://wokwi.com) en el navegador.

### 3. C/C++ (automática)

Esta extensión la instala PlatformIO automáticamente. Provee autocompletado y resaltado de C++.

### 4. Markdown Preview Enhanced (recomendada)

**Para qué:** Ver los archivos `.md` con formato bonito.

**Cómo instalar:** Busca `Markdown Preview Enhanced` e instala.

**Cómo usar:** Abre cualquier archivo `.md` y presiona `Cmd + K` seguido de `V` para ver el preview.

### 5. GitLens (opcional, muy útil)

**Para qué:** Ver historial de Git directamente en el editor.

Busca `GitLens — Git supercharged` e instala.

---

## ⚙️ Configuración recomendada

### Atajos de teclado básicos

| Acción | Atajo Mac | Atajo Windows/Linux |
|---|---|---|
| Abrir terminal | `Ctrl + ñ` | `Ctrl + ñ` |
| Buscar archivo | `Cmd + P` | `Ctrl + P` |
| Paleta de comandos | `Cmd + Shift + P` | `Ctrl + Shift + P` |
| Guardar | `Cmd + S` | `Ctrl + S` |
| Buscar en archivo actual | `Cmd + F` | `Ctrl + F` |
| Buscar en todo el proyecto | `Cmd + Shift + F` | `Ctrl + Shift + F` |
| Comentar línea | `Cmd + /` | `Ctrl + /` |
| Duplicar línea | `Shift + Option + ↓` | `Shift + Alt + ↓` |

### Configuración recomendada (settings.json)

Abre la paleta de comandos (`Cmd + Shift + P`) → escribe **"Preferences: Open Settings (JSON)"** → presiona Enter.

Pega esto al final del archivo (antes de la última `}`):

```json
{
    "editor.fontSize": 14,
    "editor.tabSize": 2,
    "editor.formatOnSave": true,
    "files.autoSave": "afterDelay",
    "files.autoSaveDelay": 1000,
    "terminal.integrated.fontSize": 13,
    "workbench.colorTheme": "Default Dark Modern"
}
```

Esto activa:
- Auto-guardado cada segundo
- Formateo automático al guardar
- Tamaño de fuente cómodo

---

## 📂 Cómo abrir el proyecto

### Si ya clonaste el repositorio

1. Abre VS Code
2. Menú **File → Open Folder...**
3. Navega hasta la carpeta `Robot diferencial iOS`
4. Click en **"Open"**

### Si vas a clonar el repositorio desde VS Code

1. Abre VS Code
2. `Cmd + Shift + P` → escribe **"Git: Clone"**
3. Pega la URL del repositorio
4. Selecciona dónde guardarlo

⚠️ **Importante para este proyecto:**

Cuando trabajes con PlatformIO, **abre la carpeta `firmware/esp32/`** directamente, no la raíz del proyecto. PlatformIO espera ver `platformio.ini` en la raíz del workspace.

```bash
# Desde terminal
cd "ruta/al/proyecto/firmware/esp32"
code .
```

---

## 🆘 Problemas comunes

### "VS Code no detecta PlatformIO después de instalarlo"

**Solución:**
1. Cierra VS Code completamente
2. Vuelve a abrirlo
3. Espera 1-2 minutos al primer arranque (PlatformIO se inicializa)

### "Las extensiones se ven en gris / inactivas"

**Solución:** Click derecho sobre la extensión → "Enable".

### "VS Code está en otro idioma y quiero cambiarlo"

1. `Cmd + Shift + P`
2. Escribe: `Configure Display Language`
3. Selecciona el idioma (puede pedir instalar el paquete de idioma)
4. Reinicia VS Code

### "No encuentro la terminal"

Menú **Terminal → New Terminal**, o atajo `` Ctrl + n ``.

---

## ✅ Checklist al terminar

- [ ] VS Code instalado y abriendo correctamente
- [ ] Extensión PlatformIO IDE instalada
- [ ] (Opcional) Extensión Wokwi Simulator instalada
- [ ] (Opcional) Markdown Preview Enhanced instalada
- [ ] Sabes abrir la terminal integrada
- [ ] Sabes abrir la paleta de comandos

---

[← Anterior: Prerrequisitos](01-prerequisitos.md) | [Siguiente: PlatformIO →](03-platformio.md)
