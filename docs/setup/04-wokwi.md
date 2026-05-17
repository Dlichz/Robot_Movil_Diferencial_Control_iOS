# 04 — Wokwi

> **Wokwi** es un simulador online de microcontroladores. Permite probar tu código sin tener el hardware físico, ideal para validar lógica antes de invertir en componentes.

---

## 🎯 ¿Qué hace Wokwi?

- Simula el ESP32 (y muchos otros chips) ejecutando tu código real
- Provee componentes virtuales (LEDs, sensores, pantallas)
- Tiene **analizador lógico** y monitor serial integrados
- Soporta WiFi y Bluetooth simulados (limitado)

---

## 🆚 Dos formas de usar Wokwi

### Opción A: Wokwi en el navegador (recomendada para empezar)

- **URL:** https://wokwi.com
- **Ventajas:** Sin instalaciones, compila en sus servidores, siempre funciona
- **Desventajas:** Requiere internet, no integra con tu proyecto PlatformIO

### Opción B: Extensión Wokwi para VS Code

- Se instala como extensión
- Usa el `firmware.bin` compilado por PlatformIO
- **Ventajas:** Integrado con tu flujo de desarrollo
- **Desventajas:** Tiene bugs ocasionales en Mac (especialmente el monitor serial)

⚠️ **Recomendación del proyecto:** Para esta etapa, usa **Wokwi en el navegador**. Es más estable y rápido.

---

## 🌐 Opción A: Wokwi en el navegador

### Setup inicial

1. Ve a **https://wokwi.com**
2. Click en **"Log in"** (arriba a la derecha)
3. Inicia sesión con GitHub o Google
4. Listo, no requiere instalación

### Cómo abrir el proyecto

#### Método 1: Crear desde cero

1. Click en **"New Project"** → **"ESP32"**
2. Se abre un editor con 2 archivos:
   - `sketch.ino` — código (formato Arduino)
   - `diagram.json` — esquemático

#### Método 2: Cargar el proyecto existente

1. Abre **https://wokwi.com**
2. Click en **"New Project"** → **"ESP32"**
3. En la pestaña **`sketch.ino`**, borra el contenido y pega el código de `firmware/esp32/src/main.cpp`
   - ⚠️ **Importante:** quita la línea `#include <Arduino.h>` (Wokwi web no la necesita)
4. En la pestaña **`diagram.json`**, borra y pega el contenido de `firmware/esp32/diagram.json`
5. Click en el botón **▶ verde** para arrancar la simulación

### Interfaz de Wokwi web

```
┌──────────────────────────────────────────────────────┐
│  💾 SAVE  📤 SHARE   nombre-proyecto                  │
├──────────────────────────────────────────────────────┤
│                                                       │
│  [sketch.ino] [diagram.json] [Library Manager]        │
│                                                       │
│  Aquí escribes/pegas el código                        │
│                                                       │
│                                                       │
├────────────────────────┬─────────────────────────────┤
│                        │ [Simulation]                 │
│                        │  ▶ ⏸ 🔄  (controles)        │
│                        │                              │
│                        │  Aquí aparece el circuito    │
│                        │                              │
│  Monitor Serial:       │                              │
│  > _                   │                              │
└────────────────────────┴─────────────────────────────┘
```

### Cómo usar el monitor serial

1. Después de darle ▶ Play, busca el **monitor serial** en la parte inferior izquierda
2. Si no aparece, presiona **`Ctrl + Shift + S`** para mostrarlo
3. Click dentro del monitor → escribe comandos (ej. `w`)
4. Presiona Enter

---

## 💻 Opción B: Wokwi como extensión de VS Code

### Instalación

1. En VS Code, ve al panel de extensiones (`Cmd + Shift + X`)
2. Busca **"Wokwi Simulator"**
3. Click en **"Install"**
4. Reinicia VS Code

### Activar licencia gratuita

Wokwi requiere licencia incluso en su versión gratis (para uso personal).

1. `Cmd + Shift + P` → escribe **"Wokwi: Request a new License"**
2. Se abre el navegador
3. Inicia sesión con GitHub o Google
4. Acepta los términos
5. Vuelve a VS Code — la licencia se activa sola

### Archivos necesarios en el proyecto

Para usar Wokwi en VS Code, tu proyecto debe tener:

```
firmware/esp32/
├── platformio.ini
├── diagram.json       # Esquemático
├── wokwi.toml         # Configuración de Wokwi
└── src/
    └── main.cpp
```

#### `diagram.json`

Define los componentes del circuito virtual. Ejemplo mínimo:

```json
{
  "version": 1,
  "author": "Tu Nombre",
  "editor": "wokwi",
  "parts": [
    {
      "type": "board-esp32-devkit-c-v4",
      "id": "esp",
      "top": 0,
      "left": 0,
      "attrs": {}
    }
  ],
  "connections": []
}
```

#### `wokwi.toml`

Le dice a Wokwi dónde está el binario compilado:

```toml
[wokwi]
version = 1
firmware = '.pio/build/esp32dev/firmware.bin'
elf = '.pio/build/esp32dev/firmware.elf'
```

⚠️ **Importante:** la ruta `esp32dev` debe coincidir con el nombre del entorno en `platformio.ini`. Si tu entorno se llama `esp32`, cambia a `.pio/build/esp32/`.

### Cómo correr la simulación

1. Compila el código primero: botón ✓ o `pio run`
2. Abre el archivo `diagram.json` en VS Code
3. `Cmd + Shift + P` → **"Wokwi: Start Simulator"**
4. Se abre el simulador en una pestaña de VS Code
5. Click en el botón **▶ verde** para arrancar

### El bug del monitor serial vacío

Si el monitor de Wokwi no muestra el output del ESP32:

**Solución 1:** Click DENTRO del monitor para enfocarlo, luego presiona Reset 🔄

**Solución 2:** Detén, cierra y reabre el simulador

**Solución 3:** Si nada funciona, usa wokwi.com en el navegador

---

## 🧩 Componentes que SÍ existen en Wokwi

Estos son los más útiles para este proyecto:

| Componente | ID en Wokwi |
|---|---|
| ESP32 DevKit | `board-esp32-devkit-c-v4` |
| LED | `wokwi-led` |
| Resistencia | `wokwi-resistor` |
| Pulsador | `wokwi-pushbutton` |
| Sensor ultrasónico (sustituto del ToF) | `wokwi-hc-sr04` |
| MPU6050 | `wokwi-mpu6050` |
| Pantalla OLED | `wokwi-ssd1306` |
| Analizador lógico | `wokwi-logic-analyzer` |
| Slide switch | `wokwi-slide-switch` |

### Componentes que NO existen (cuidado)

- ❌ `wokwi-l298n` o `wokwi-tb6612fng` (no hay drivers de motores nativos)
- ❌ `wokwi-dc-motor` (no hay motores DC simulables)
- ❌ `wokwi-vl53l0x` (no hay sensor ToF, usar HC-SR04 como sustituto)

Para drivers de motores en Wokwi, se simulan con LEDs que representan las señales de control.

---

## 📚 Recursos útiles

- [Documentación oficial de Wokwi](https://docs.wokwi.com/)
- [Lista de componentes disponibles](https://docs.wokwi.com/parts/)
- [Ejemplos de proyectos](https://wokwi.com/projects)

---

## 🆘 Problemas comunes

### "Wokwi no encuentra el firmware.bin"

- Verifica que compilaste primero (`pio run` o botón ✓)
- Verifica que la ruta en `wokwi.toml` coincide con tu carpeta de build
- Si tu env es `esp32dev` → ruta `.pio/build/esp32dev/firmware.bin`
- Si tu env es `esp32` → ruta `.pio/build/esp32/firmware.bin`

### "Los componentes no aparecen en el simulador"

Verifica que los `type` en `diagram.json` sean válidos (lista arriba). Wokwi ignora silenciosamente componentes inexistentes.

### "La simulación está pausada al abrirse"

Click en el botón **▶ verde** para arrancar. No corre automáticamente.

### "El monitor serial está vacío en VS Code"

Bug conocido en Mac. Soluciones (en orden):
1. Click dentro del monitor + Reset 🔄
2. Cerrar y reabrir simulador
3. Cambiar a wokwi.com en el navegador

### "Wokwi web no compila mi código"

Verifica:
- No tienes `#include <Arduino.h>` (Wokwi web no lo necesita, sí da error)
- No tienes errores de sintaxis (revisa el panel de errores debajo del editor)

---

## ✅ Checklist al terminar

- [ ] Tengo cuenta en Wokwi (vía GitHub o Google)
- [ ] Puedo abrir https://wokwi.com sin problemas
- [ ] (Opcional) Extensión Wokwi instalada y activada en VS Code
- [ ] Sé la diferencia entre wokwi.com y la extensión

---

[← Anterior: PlatformIO](03-platformio.md) | [Siguiente: Fritzing →](05-fritzing.md)
