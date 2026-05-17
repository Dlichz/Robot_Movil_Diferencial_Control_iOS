# 07 — Flashear el ESP32

> Esta guía explica cómo subir (flashear) el código compilado al ESP32 físico, y cómo verificar que está funcionando correctamente.

---

## 🎯 ¿Qué significa "flashear"?

"Flashear" es la jerga embebida para **subir un firmware (binario) a la memoria flash del microcontrolador**. Es lo mismo que hace:

- Apple cuando actualiza iOS
- Tesla cuando actualiza tu auto (OTA)
- DJI con tu dron

La diferencia es que tú lo haces vía cable USB a tu chip.

---

## 📋 Antes de empezar

### Prerrequisitos

- [x] ESP32 DOIT DevKit V1 (o compatible)
- [x] Cable USB con **datos** (no solo carga)
- [x] PlatformIO instalado y funcionando
- [x] Código compilado exitosamente (`pio run` con `[SUCCESS]`)
- [x] Puerto USB libre en la Mac

### Verificar que el cable tiene datos

Los cables USB de "solo carga" son comunes y causan mucha confusión. Para verificar:

1. Conecta el ESP32 al Mac con tu cable
2. En el ESP32 debería encender un **LED rojo** (LED de power)
3. Ejecuta en terminal:
```bash
ls /dev/cu.*
```
4. Si aparece algo como `/dev/cu.usbserial-0001` → cable bueno
5. Si solo aparece `Bluetooth-Incoming-Port` → cable malo, prueba otro

---

## 🔌 Conectar el ESP32

### Pasos físicos

1. Toma el cable USB
2. El extremo **micro-USB** va al ESP32 (puerto trapezoidal pequeño)
3. El otro extremo (USB-A o USB-C) va al Mac
4. Asegúrate de que está bien insertado

### Qué deberías ver

- ✅ **LED rojo encendido** en la placa (LED de "power")
- ✅ Posiblemente un **LED azul parpadea** una vez (LED en GPIO 2)

Si el LED rojo no enciende:
- Prueba otro cable
- Prueba otro puerto USB del Mac
- Verifica que el ESP32 no tenga daños visibles

---

## 🔍 Verificar que macOS detecta el ESP32

### En terminal

```bash
ls /dev/cu.*
```

### Resultados posibles

#### ✅ Caso A: Detectado correctamente

```
/dev/cu.Bluetooth-Incoming-Port
/dev/cu.usbserial-0001
```

o similares con `wchusbserial` o `SLAB_USBtoUART`. **¡Puedes saltar a la sección "Flashear el código"!**

#### ❌ Caso B: Solo aparece Bluetooth

Significa que el sistema no detecta el ESP32. Posibles causas:

1. **Cable solo de carga** — prueba otro cable
2. **Falta driver USB-Serial** — sigue la sección siguiente

---

## 💾 Instalar driver USB-Serial (si hace falta)

El ESP32 DOIT V1 puede usar uno de dos chips USB-Serial:

### Identificar tu chip

Mira tu ESP32 cerca del puerto micro-USB. Hay un chip pequeño cuadrado:

- Si dice **"CP2102"** → driver de Silicon Labs
- Si dice **"CH340"** o **"CH340G"** → driver WCH

Si no lo ves bien, instala primero el CP2102 (es el más común en placas DOIT).

### Driver CP2102 (Silicon Labs)

1. Ve a: https://www.silabs.com/developers/usb-to-uart-bridge-vc-drivers
2. Acepta los términos
3. Descarga **"CP210x VCP Mac OSX Driver"**
4. Abre el `.dmg` descargado
5. Ejecuta el instalador
6. Te pedirá password del Mac
7. **Reinicia el Mac** (importante en macOS reciente)
8. Verifica:
```bash
ls /dev/cu.*
```

### Driver CH340 (WCH)

1. Ve a: https://github.com/WCHSoftGroup/ch34xser_macos
2. Descarga el `.dmg` desde la última release
3. Instala
4. En macOS reciente: **System Settings → Privacy & Security**
5. Verás un mensaje pidiendo permitir el driver — click en **"Allow"**
6. **Reinicia el Mac**
7. Verifica con `ls /dev/cu.*`

---

## 🚀 Flashear el código

### Asegúrate de estar en la carpeta correcta

```bash
cd "ruta/al/proyecto/firmware/esp32"
```

### Método 1: Por terminal (recomendado)

```bash
pio run --target upload
```

### Método 2: Botón en VS Code

En la **barra azul inferior** de VS Code, hay una flecha **→**. Pasa el mouse para confirmar que dice **"PlatformIO: Upload"** y haz click.

### Qué vas a ver

```
Processing esp32dev (platform: espressif32; board: esp32dev; framework: arduino)
--------------------------------------------------------------------------------
...
Configuring upload protocol...
CURRENT: upload_protocol = esptool
Looking for upload port...
Auto-detected: /dev/cu.usbserial-0001
Uploading .pio/build/esp32dev/firmware.bin
esptool.py v4.11.0
Serial port /dev/cu.usbserial-0001
Connecting....
Chip is ESP32-D0WD-V3 (revision v3.1)
Features: WiFi, BT, Dual Core, 240MHz...
MAC: xx:xx:xx:xx:xx:xx
Uploading stub...
...
Writing at 0x00010000... (10 %)
Writing at 0x00020000... (20 %)
...
Writing at 0x00051725... (100 %)
Hash of data verified.
Leaving...
Hard resetting via RTS pin...
============== [SUCCESS] Took 8.21 seconds ==============
```

**`[SUCCESS]` en verde = tu código está corriendo en hardware real.** 🎉

---

## 📺 Verificar que funciona — Monitor serial

### Abrir el monitor

```bash
pio device monitor
```

O click en el ícono **⚡** en la barra inferior de VS Code.

### Qué deberías ver

```
--- Terminal on /dev/cu.usbserial-0001 | 115200 8-N-1
--- Quit: Ctrl+C | Menu: Ctrl+T | Help: Ctrl+T followed by Ctrl+H

rst:0x1 (POWERON_RESET),boot:0x13 (SPI_FAST_FLASH_BOOT)
configsip: 0, SPIWP:0xee
...

=== Robot Diferencial ESP32 - Test Motores ===
Comandos disponibles:
  w = adelante   s = atras
  a = girar izq  d = girar der
  x = detener
  + = mas rapido - = mas lento
>> DETENIDO
```

### Si el monitor está vacío

Significa que te conectaste **después** de que el ESP32 arrancó (y se perdió el mensaje inicial). Soluciones:

1. **Presiona el botón EN (reset)** en la placa del ESP32
2. O ejecuta `Ctrl + T` seguido de `Ctrl + R` (reset desde el monitor)
3. Verás el mensaje aparecer

### Interactuar con el código

1. Click dentro del monitor (para que reciba lo que tipeas)
2. Escribe **`w`** y presiona Enter
3. Deberías ver:
```
>> ADELANTE
```

Prueba todos los comandos:

| Comando | Esperado |
|---|---|
| `w` | `>> ADELANTE` |
| `s` | `>> ATRAS` |
| `a` | `>> GIRO IZQUIERDA` |
| `d` | `>> GIRO DERECHA` |
| `x` | `>> DETENIDO` |
| `+` | `Velocidad: 220` |
| `-` | `Velocidad: 180` |

### Salir del monitor

`Ctrl + C`

---

## 🔬 Bonus: Verificar señales con multímetro

Si tienes multímetro, puedes confirmar que los pines del ESP32 están enviando las señales correctas (sin el TB6612FNG aún conectado).

### Test de pines de dirección

Modo del multímetro: **DC Voltage**

1. Pinza negra → cualquier pin **GND** del ESP32
2. Pinza roja → **GPIO 26** (AIN1)
3. En monitor serial, envía `w`. Mide:
   - GPIO 26 ≈ 3.3V (HIGH)
   - GPIO 27 ≈ 0V (LOW)
4. Envía `s`. Mide:
   - GPIO 26 ≈ 0V (LOW)
   - GPIO 27 ≈ 3.3V (HIGH)
5. Envía `x`. Ambos ≈ 0V.

### Test de pin PWM

Con `w` enviado, mide **GPIO 25** (PWMA):

- Multímetro común: ~2.5V (promedia el PWM)
- Osciloscopio: onda cuadrada a 1 kHz

Cambia velocidad con `+` y `-`, el voltaje promedio variará.

---

## 🆘 Problemas comunes

### "Connecting......" se queda colgado

El ESP32 está en modo raro. Solución:

1. Inicia el comando upload
2. **Mantén presionado el botón BOOT** (también llamado IO0) en la placa
3. Cuando empiece a escribir, **suelta BOOT**
4. La carga continúa normalmente

### "Wrong boot mode detected"

Similar al anterior. Solución:

1. Presiona el botón **EN** (reset)
2. Inmediatamente click en Upload
3. Si sigue, mantén **BOOT** durante todo el upload

### "Permission denied: /dev/cu.usbserial-XXXX"

Permisos del puerto serial:

```bash
sudo chmod 666 /dev/cu.usbserial-0001
```

### "esptool.py: command not found"

PlatformIO no está cargando esptool. Solución:

1. Cierra y reabre la terminal de VS Code
2. Verifica con `which pio`
3. Si todavía falla, reinstala PlatformIO

### "El ESP32 se reinicia constantemente"

Problemas posibles:

1. **Cable defectuoso** (no aporta suficiente corriente)
2. **Puerto USB del Mac saturado** — prueba otro puerto
3. **Código con bug** que causa crash — revisa logs en serial
4. **Watchdog activado** — el código tarda mucho en una función

### "Monitor serial muestra caracteres raros"

Velocidad del monitor incorrecta. Tu `platformio.ini` debe tener:

```ini
monitor_speed = 115200
```

Si pusiste otra velocidad, ajusta para que coincida con el `Serial.begin()` del código.

---

## 📊 Métricas que debes esperar

Cuando un upload es exitoso, verás:

| Métrica | Valor típico |
|---|---|
| Tamaño del firmware | 200-300 KB |
| Velocidad de upload | ~500 kbit/s |
| Tiempo total | 5-10 segundos |
| Uso de RAM | <20% (típico < 10%) |
| Uso de Flash | <30% (típico ~21%) |

Si excedes mucho estos números, tu código tiene algo extraño que conviene revisar.

---

## ✅ Checklist al terminar

- [ ] El ESP32 está conectado y el LED rojo encendido
- [ ] `ls /dev/cu.*` muestra un puerto `usbserial`
- [ ] (Si hizo falta) Driver USB-Serial instalado
- [ ] `pio run --target upload` termina con `[SUCCESS]`
- [ ] Monitor serial muestra el mensaje de bienvenida
- [ ] Puedo enviar comandos y ver respuestas

---

## 🎓 Resumen del flujo

```
1. Escribir código en src/main.cpp
2. pio run                           ← compilar
3. pio run --target upload           ← flashear
4. pio device monitor                ← ver output
5. (Iterar)
```

Este es **exactamente el ciclo profesional** de desarrollo embebido. Lo que aprendiste aquí te sirve para cualquier proyecto con ESP32, ESP8266, STM32 y muchos otros chips.

---

[← Anterior: Git y GitHub](06-git-github.md) | [Volver al índice](README.md)
