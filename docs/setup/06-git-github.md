# 06 — Git y GitHub

> **Git** es el sistema de control de versiones más usado del mundo. **GitHub** es la plataforma online donde se alojan repositorios Git. Juntos te permiten guardar el historial completo de tu proyecto y compartirlo.

---

## 🎯 ¿Por qué Git y GitHub?

- **Historial completo** del código (puedes volver a cualquier punto del pasado)
- **Trabajar desde múltiples computadoras** sin perder cambios
- **Compartir con otros** o que descarguen el proyecto
- **Respaldo automático** en la nube
- **Estándar absoluto** en la industria

Sin Git, perder código es cuestión de tiempo. Con Git, casi imposible.

---

## 📥 Instalación de Git

### macOS

Git viene **preinstalado** en macOS reciente. Verifica:

```bash
git --version
```

Debería mostrar algo como:
```
git version 2.39.5 (Apple Git-154)
```

Si no está instalado, el sistema te pedirá instalar las **Command Line Tools** automáticamente. Acepta y espera 5 minutos.

#### Instalación manual (más reciente)

```bash
brew install git
```

### Linux

```bash
sudo apt install git    # Ubuntu/Debian
sudo dnf install git    # Fedora
```

### Windows

Descarga desde https://git-scm.com — instala con opciones por defecto.

---

## ⚙️ Configuración inicial de Git

Solo se hace **una vez por computadora**.

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tucorreo@example.com"
git config --global init.defaultBranch main
```

Usa el mismo email que en tu cuenta de GitHub.

---

## 🐙 GitHub

### Crear cuenta

1. Ve a **https://github.com**
2. Click en **"Sign up"**
3. Completa el registro con tu email
4. Verifica el correo

### Autenticación: SSH vs HTTPS

Para que tu Mac pueda **subir** código a GitHub, necesitas autenticarte. Hay dos métodos:

#### Opción A: HTTPS + Personal Access Token (más fácil)

1. En GitHub: **Settings → Developer settings → Personal access tokens → Tokens (classic)**
2. **Generate new token**
3. Marca permisos: `repo` (todos los sub-permisos)
4. Expiración: 90 días (o lo que prefieras)
5. **Generate token**
6. **Copia el token** (no se muestra otra vez)
7. La próxima vez que hagas `git push`, te pedirá usuario (tu email) y contraseña (pega el token)

#### Opción B: SSH (más profesional)

1. Genera una llave SSH:
```bash
ssh-keygen -t ed25519 -C "tucorreo@example.com"
```
2. Acepta los defaults (Enter, Enter, Enter)
3. Copia la llave pública:
```bash
cat ~/.ssh/id_ed25519.pub | pbcopy
```
4. En GitHub: **Settings → SSH and GPG keys → New SSH key**
5. Pega la llave y guarda
6. Verifica con:
```bash
ssh -T git@github.com
```
   Debería decir: `Hi <usuario>! You've successfully authenticated...`

**Recomendación:** Si es tu primera vez, usa HTTPS + token. Si vas a usar Git mucho, configura SSH.

---

## 📂 Conceptos clave de Git

### Repositorio (repo)

Una carpeta versionada por Git. Tiene una subcarpeta oculta `.git/` que guarda todo el historial.

### Commit

Una "foto" del estado de los archivos en un momento. Cada commit tiene:
- Un mensaje descriptivo
- Una fecha
- Un autor
- Un hash único

### Branch (rama)

Una línea paralela de desarrollo. La principal se llama `main` o `master`.

### Push y Pull

- **Push:** subir cambios locales al repositorio remoto (GitHub)
- **Pull:** descargar cambios del remoto al local

### Remote

El repositorio "espejo" en la nube. Típicamente se llama `origin`.

---

## 🛠️ Flujo básico de trabajo

### Caso 1: Empezar un proyecto nuevo en local y subirlo

```bash
# 1. Crear carpeta y entrar
mkdir mi-proyecto
cd mi-proyecto

# 2. Iniciar Git
git init

# 3. Crear archivos, escribir código
echo "# Mi proyecto" > README.md

# 4. Agregar archivos al "stage"
git add .

# 5. Hacer el primer commit
git commit -m "Initial commit"

# 6. Crear el repo en GitHub (vía web)
# 7. Conectar tu repo local con GitHub
git remote add origin https://github.com/tu-usuario/mi-proyecto.git
git branch -M main

# 8. Subir
git push -u origin main
```

### Caso 2: Clonar un repo existente (lo más común)

```bash
# Clonar
git clone https://github.com/tu-usuario/Robot-diferencial-iOS.git

# Entrar a la carpeta
cd Robot-diferencial-iOS

# Listo, ya tienes todo el proyecto
```

### Caso 3: Trabajar día a día

```bash
# 1. Antes de empezar, trae los últimos cambios del remoto
git pull

# 2. Trabaja: edita archivos, escribe código

# 3. Ver qué cambios hiciste
git status
git diff

# 4. Agregar cambios al stage
git add .                  # Todo
git add archivo.txt        # Solo un archivo

# 5. Hacer commit
git commit -m "Agregué función de evasión de obstáculos"

# 6. Subir al remoto
git push
```

---

## 📋 Comandos esenciales

| Comando | Descripción |
|---|---|
| `git status` | Ver estado del repo |
| `git log` | Ver historial de commits |
| `git log --oneline` | Historial compacto |
| `git diff` | Ver cambios no comiteados |
| `git add archivo` | Agregar un archivo al stage |
| `git add .` | Agregar todo al stage |
| `git commit -m "msg"` | Hacer commit |
| `git push` | Subir al remoto |
| `git pull` | Bajar del remoto |
| `git branch` | Listar ramas |
| `git checkout -b nueva-rama` | Crear y cambiar a nueva rama |
| `git merge rama` | Fusionar rama con la actual |
| `git reset HEAD~1` | Deshacer el último commit (mantiene cambios) |
| `git stash` | Guardar cambios temporalmente |

---

## 📝 Buenas prácticas de mensajes de commit

### ❌ Mal

```
fixes
asdfasdf
"trabajo del día"
```

### ✅ Bien

```
Agregar función motorA() con control PWM
Corregir lectura de encoder en GPIO 34
Actualizar pinout del TB6612FNG en documentación
```

### Convención "Conventional Commits"

```
feat: agregar lectura de MPU-6050
fix: corregir polaridad en motor B
docs: actualizar README con instrucciones de instalación
refactor: separar lógica de motores en módulo aparte
test: agregar test de control de velocidad
chore: actualizar versión de librería Adafruit_MPU6050
```

---

## 📄 El archivo `.gitignore`

Lista de archivos que **NO** se suben al repo. Para este proyecto:

```
# PlatformIO build files
.pio/
.vscode/.browse.c_cpp.db*
.vscode/c_cpp_properties.json
.vscode/launch.json
.vscode/ipch

# Mac
.DS_Store

# Backups
*.bak
*~

# Sistema
.env

# Sensibles
secrets.h
config.json
```

Si tu repo aún no tiene `.gitignore`, créalo en la raíz con ese contenido.

---

## 🔧 Configuración recomendada para este proyecto

### Estructura del repo

Si vas a hacer fork o tu propio repo, este es el `.gitignore` óptimo:

```bash
# Ejecutar desde la raíz del proyecto
cat > .gitignore << 'EOF'
# PlatformIO
.pio/
.vscode/.browse.c_cpp.db*
.vscode/c_cpp_properties.json
.vscode/launch.json
.vscode/ipch

# macOS
.DS_Store
.AppleDouble
.LSOverride

# Fritzing
*.fzz~
*.bak

# CAD temp
*.bak.*

# Build outputs
build/
dist/

# IDE
.idea/
*.swp
EOF
```

---

## 🆘 Problemas comunes

### "Permission denied (publickey)"

Tu Mac no tiene autenticación configurada. Sigue la sección de **Autenticación** arriba.

### "fatal: not a git repository"

Estás en una carpeta que no es un repo Git. Ejecuta `git init` o `cd` a la carpeta correcta.

### "Updates were rejected because the remote contains work..."

Alguien (o tú desde otra compu) subió cambios después de tu último pull. Solución:

```bash
git pull --rebase
git push
```

### "I accidentally committed sensitive data"

Si subiste contraseñas o tokens por error:

1. **Cambia las contraseñas/tokens** inmediatamente (el daño ya está hecho)
2. Para limpiar el historial:
```bash
git rm --cached archivo-sensible
git commit -m "Eliminar archivo sensible"
git push
```

Pero el archivo sigue en el historial. Para borrarlo completamente, usa `git filter-repo` o `BFG Repo-Cleaner`.

### "Quiero deshacer cambios locales sin perder nada"

```bash
git stash         # Guarda cambios temporalmente
git pull          # Trae cambios remotos
git stash pop     # Restaura tus cambios
```

---

## 🎓 Recursos para profundizar

- [Pro Git Book (gratis)](https://git-scm.com/book/en/v2)
- [Aprende Git con Atlassian](https://www.atlassian.com/git/tutorials)
- [Oh Shit, Git!?! (cuando algo sale mal)](https://ohshitgit.com/)

---

## ✅ Checklist al terminar

- [ ] Git instalado y `git --version` funciona
- [ ] `user.name` y `user.email` configurados globalmente
- [ ] Cuenta de GitHub creada
- [ ] Autenticación configurada (token HTTPS o llave SSH)
- [ ] Sé hacer `git clone`, `git add`, `git commit`, `git push`, `git pull`
- [ ] Entiendo qué hace `.gitignore`

---

[← Anterior: Fritzing](05-fritzing.md) | [Siguiente: Flashear ESP32 →](07-flashear-esp32.md)
