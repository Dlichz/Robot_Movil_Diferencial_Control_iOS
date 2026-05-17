# 03 — PlatformIO

> **PlatformIO** es el sistema de build profesional para microcontroladores. Es lo que toma tu código C++ y lo convierte en un binario que el ESP32 puede ejecutar.

---

## 🎯 ¿Qué es PlatformIO?

PlatformIO es un ecosistema de desarrollo de software libre y de código abierto para sistemas embebidos y aplicaciones de Internet de las Cosas. Maneja:

- **Compilación** del código C++ a binario para ESP32 (u otros chips)
- **Descarga de librerías** automáticamente
- **Gestión de toolchains** (compiladores específicos)
- **Subida del firmware** a la placa
- **Monitoreo del puerto serial**
- **Tests unitarios**

---

## 🆚 ¿Por qué no Arduino IDE?

| Característica | Arduino IDE | PlatformIO |
|---|---|---|
| Compilación | Sí | Sí (más rápido) |
| Gestión de librerías | Manual | Automática (declaras en `platformio.ini`) |
| Estructura del proyecto | Plana, 1 archivo `.ino` | Profesional, separa `src/`, `lib/`, `include/`, `test/` |
| IDE | Propio (limitado) | Funciona en VS Code (mucho mejor) |
| Soporta múltiples chips | Sí, con plugins | Sí, nativo (1000+ placas) |
| Reproducibilidad | Dependiente del entorno | Configuración versionable en `platformio.ini` |
| Industria | Hobby | Profesional |

PlatformIO es **profesional**.

---

## 📥 Instalación

PlatformIO se instala como **extensión de VS Code**, no como aplicación independiente.

### Pasos

1. Abre VS Code
2. Ve al panel de extensiones (`Cmd + Shift + X`)
3. Busca **"PlatformIO IDE"**
4. Click en **"Install"**
5. ⏳ Espera 3-5 minutos
   - PlatformIO descarga:
     - Python embebido (~100 MB)
     - Toolchain de Xtensa para ESP32 (~150 MB)
     - Framework de Arduino para ESP32 (~50 MB)
6. Cuando termine, VS Code pedirá reiniciar — acepta
7. Al reabrir, verás la **carita de alien** 👽 en la barra lateral izquierda

### Verificación

Click en el ícono 👽 → debería aparecer un panel con "PROJECT TASKS", "QUICK ACCESS", "Debug", "Miscellaneous".

---

## 🎓 Conceptos clave

### El archivo `platformio.ini`

Es el **corazón** del proyecto. Define qué chip, qué framework y qué librerías usar.

Ejemplo del archivo de este proyecto:

```ini
[env:esp32dev]
platform = espressif32
board = esp32dev
framework = arduino
monitor_speed = 115200
```

Línea por línea:

| Línea | Significado |
|---|---|
| `[env:esp32dev]` | Nombre del entorno. Puedes tener varios (por ej. `[env:esp32]`, `[env:esp32-debug]`) |
| `platform = espressif32` | Familia de chips (Espressif = ESP32, ESP8266) |
| `board = esp32dev` | Modelo específico de placa (ESP32 DevKit V1) |
| `framework = arduino` | Framework de programación (alternativa: ESP-IDF) |
| `monitor_speed = 115200` | Velocidad del puerto serial en baudios |

### Estructura de un proyecto PlatformIO

```
mi-proyecto/
├── platformio.ini          # Configuración del proyecto
├── src/
│   └── main.cpp            # Código principal
├── include/                # Headers personalizados (.h)
├── lib/                    # Librerías propias del proyecto
├── test/                   # Tests unitarios
└── .pio/                   # Carpeta generada (NO editar, NO subir a Git)
    └── build/
        └── esp32dev/
            ├── firmware.bin    # Binario compilado
            └── firmware.elf    # Versión con info de debug
```

### Diferencias con Arduino IDE

| Arduino IDE | PlatformIO |
|---|---|
| Un solo archivo `.ino` | Múltiples `.cpp` y `.h` en `src/` |
| `#include <Arduino.h>` automático | Debes incluirlo manualmente |
| Funciones se pueden usar antes de declararlas | Necesitas declaraciones adelantadas |
| Librerías globales | Librerías por proyecto |

---

## 🛠️ Comandos esenciales

PlatformIO funciona tanto por **interfaz gráfica** (botones en VS Code) como por **terminal** (`pio`).

### Por terminal

| Comando | Descripción |
|---|---|
| `pio run` | Compilar |
| `pio run --target upload` | Compilar + subir al ESP32 |
| `pio run --target clean` | Limpiar archivos compilados |
| `pio device monitor` | Abrir monitor serial |
| `pio device list` | Listar puertos seriales detectados |
| `pio update` | Actualizar plataformas y librerías |
| `pio platform list` | Ver plataformas instaladas |

### Por interfaz gráfica

En la barra inferior azul de VS Code aparecen estos íconos (de izquierda a derecha):

| Ícono | Función | Equivalente terminal |
|---|---|---|
| 🏠 | PIO Home | — |
| ✓ | Build | `pio run` |
| → | Upload | `pio run --target upload` |
| 🗑️ | Clean | `pio run --target clean` |
| 📁 | Tasks | — |
| ⚡ | Serial Monitor | `pio device monitor` |

---

## 🚀 Crear un proyecto nuevo (referencia)

Si quieres empezar otro proyecto en el futuro:

1. Click en el ícono 👽 de PlatformIO
2. Click en **"PIO Home"** → **"+ New Project"**
3. Llena:
   - **Name:** nombre del proyecto
   - **Board:** busca tu placa (ej. `ESP32 Dev Module`)
   - **Framework:** `Arduino`
   - **Location:** carpeta donde guardarlo
4. Click **"Finish"**
5. Espera a que se inicialice

Para este proyecto, **no necesitas crear uno nuevo** — ya está creado en `firmware/esp32/`.

---

## 🔧 Cómo agregar una librería

Cuando llegues a sensores, vas a necesitar librerías como Adafruit_MPU6050 o Adafruit_VL53L0X.

### Método 1: Editar `platformio.ini` (recomendado, versionable)

Agrega bajo el entorno:

```ini
[env:esp32dev]
platform = espressif32
board = esp32dev
framework = arduino
monitor_speed = 115200
lib_deps =
    adafruit/Adafruit MPU6050 @ ^2.2.4
    adafruit/Adafruit VL53L0X @ ^1.2.4
```

La próxima vez que compiles, PlatformIO las descarga automáticamente.

### Método 2: Por interfaz

1. Click en el ícono 👽
2. **PIO Home → Libraries**
3. Busca la librería
4. Click en **"Add to Project"**

---

## 🆘 Problemas comunes

### "command not found: pio"

Pasa cuando usas una terminal externa (no la integrada de VS Code).

**Solución 1:** Usa la terminal interna de VS Code (`Ctrl + ñ`). Esa SÍ tiene `pio` en el PATH.

**Solución 2 (permanente):** Agrega esta línea a tu `~/.zshrc`:

```bash
export PATH="$PATH:$HOME/.platformio/penv/bin"
```

Luego ejecuta `source ~/.zshrc` para aplicar el cambio.

### "Failed to connect to ESP32: Wrong boot mode detected"

El ESP32 está en estado raro.

**Solución:** Mantén presionado el botón **BOOT** (o **IO0**) en la placa mientras inicias el upload. Suéltalo cuando empiece a escribir.

### "Permission denied: /dev/cu.usbserial-XXXX"

En Mac, a veces el puerto serial no tiene permisos.

**Solución:**
```bash
sudo chmod 666 /dev/cu.usbserial-0001
```

### "Compilación tarda muchísimo la primera vez"

**Es normal.** La primera vez PlatformIO descarga el toolchain (~200 MB). Las siguientes compilaciones son rápidas (5-15 segundos).

### "Errores que `Serial` no existe, `pinMode` no existe..."

Falta `#include <Arduino.h>` al inicio de `main.cpp`. En PlatformIO no es automático como en Arduino IDE.

---

## ✅ Checklist al terminar

- [ ] PlatformIO instalado como extensión
- [ ] Veo el ícono 👽 en VS Code
- [ ] Puedo abrir el proyecto `firmware/esp32/` y ver `platformio.ini`
- [ ] Sé compilar con el botón ✓ o con `pio run`
- [ ] Sé que el binario sale en `.pio/build/esp32dev/firmware.bin`

---

[← Anterior: VS Code](02-vscode.md) | [Siguiente: Wokwi →](04-wokwi.md)
