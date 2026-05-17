# 01 — Prerrequisitos

> Antes de instalar las herramientas, necesitas tener listo el sistema, las cuentas y el hardware básico.

---

## 💻 Sistema operativo

### macOS (recomendado, este proyecto se desarrolló aquí)

- **Versión mínima:** macOS 12 (Monterey) o superior
- **Versión usada en el proyecto:** macOS Sonoma / Sequoia
- **Chip:** Intel o Apple Silicon (M1/M2/M3/M4) — ambos funcionan

### Linux

- Ubuntu 20.04+, Fedora 36+, o equivalente
- Todas las herramientas funcionan, pero algunos comandos de las guías cambian

### Windows

- Windows 10 o 11
- Algunas herramientas (como Fritzing) tienen mejor experiencia en Mac/Linux

---

## 🛠️ Hardware necesario

### Mínimo para empezar

- Computadora con al menos 8 GB de RAM
- 10 GB de espacio libre en disco
- Conexión a internet estable

### Para programar el robot

- **ESP32 DevKit V1** (30 pines, basado en ESP32-WROOM-32)
- **Cable USB con datos** (NO solo de carga)
  - Recomendado: USB-A a Micro-USB, o USB-C a Micro-USB

### Para el robot completo (no necesario para programar)

- Driver de motores TB6612FNG
- 2× Micro motorreductor N20 con encoder
- Sensor ToF VL53L0X
- Giroscopio MPU-6050
- Batería LiPo 2S 7.4V 2200 mAh
- Módulo de carga USB-C para LiPo 2S
- 2× Módulos Mini-360 (reguladores DC-DC)
- Interruptor SPST + fusible PPTC
- Protoboard + cables jumper
- Multímetro (opcional, muy recomendado)

---

## 👤 Cuentas necesarias

### Obligatorias

| Servicio | Para qué |
|---|---|
| [GitHub](https://github.com) | Versionado del código, descargar el repositorio |
| [Wokwi](https://wokwi.com) | Simulador online (login con GitHub o Google) |

### Opcionales (recomendadas)

| Servicio | Para qué |
|---|---|
| [Fritzing](https://fritzing.org) | Si quieres compartir tus diagramas |
| [Foro de Fritzing](https://forum.fritzing.org) | Descargar componentes custom |
| [PlatformIO](https://platformio.org) | No estrictamente necesaria pero útil |

---

## 🔧 Conocimientos previos útiles (no obligatorios)

Este proyecto está documentado para que cualquiera pueda seguirlo, pero te será más fácil si tienes nociones básicas de:

- **Programación en C/C++** o cualquier lenguaje
- **Electrónica básica** (qué es voltaje, corriente, resistencia)
- **Línea de comandos** (terminal de Mac/Linux)
- **Git** (clonar repositorios, commits)

Si no tienes ninguno de estos, no te preocupes — las guías incluyen explicaciones de los conceptos clave.

---

## ✅ Checklist antes de continuar

Antes de pasar a la siguiente guía, asegúrate de tener:

- [ ] Tu Mac/PC con el sistema operativo actualizado
- [ ] Al menos 10 GB de espacio libre en disco
- [ ] Cuenta de GitHub creada
- [ ] Conexión a internet estable
- [ ] (Opcional) ESP32 + cable USB para pruebas con hardware real

---

## 🆘 Problemas comunes

### "Mi Mac es antiguo, ¿funcionará?"

Si tu Mac soporta macOS 12 o superior, sí. Cualquier MacBook desde 2017 en adelante debería andar sin problemas.

### "Tengo Windows, ¿puedo seguir el proyecto?"

Sí, pero las guías están escritas con comandos de Mac. Necesitarás traducir algunos a PowerShell o cmd. La lógica es idéntica.

### "No tengo el ESP32 todavía"

No hay problema. Puedes:
1. Hacer todo el setup
2. Escribir y compilar el código
3. Simular en Wokwi (no requiere hardware)

El hardware solo es necesario para la fase final de pruebas.

---

[← Volver al índice](README.md) | [Siguiente: VS Code →](02-vscode.md)
