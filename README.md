# 🤖 Robot Móvil Diferencial con Control iOS

> Diseño, construcción y programación de un robot móvil de tracción diferencial controlado de forma inalámbrica desde una app iOS nativa, con evasión autónoma de obstáculos y telemetría en tiempo real.

---

## 🎯 Objetivo General

Diseñar, construir y programar un robot móvil de tracción diferencial controlado de forma inalámbrica desde una aplicación iOS nativa, integrando evasión autónoma de obstáculos, navegación precisa y telemetría en tiempo real.

---

## 📌 Objetivos Específicos

| # | Objetivo | Criterio de Éxito |
|---|----------|-------------------|
| 1 | **Hardware y energía** — Implementar un sistema electrónico basado en ESP32 con drivers TB6612FNG, motores N20 con encoder y alimentación LiPo 2S regulada y protegida | Sistema energizado y estable sin sobrecalentamiento |
| 2 | **Control de movimiento** — Lograr giros precisos usando encoders y MPU-6050 con controlador PID | Error promedio < 5° en 10 giros consecutivos de 90° y 180° |
| 3 | **Evasión autónoma** — Detectar obstáculos con VL53L0X y ejecutar maniobra de evasión con prioridad sobre el comando manual | 0 colisiones en 10 pruebas consecutivas con obstáculos a ≤ 20 cm |
| 4 | **Control remoto iOS** — Desarrollar app nativa en Swift con comunicación Bluetooth BLE para comandos en tiempo real | Latencia de respuesta < 100 ms desde la app |
| 5 | **Telemetría en tiempo real** — Visualizar en la app: distancia al obstáculo, velocidad estimada, orientación (yaw) y nivel de batería | Datos actualizados cada ≤ 200 ms |
| 6 | **Chasis 3D** — Diseñar e imprimir un chasis que integre todos los componentes de forma ordenada y desmontable | Todos los componentes fijos, accesibles y sin cables sueltos |

---

## 🛠️ Hardware

### Componentes principales

| Componente | Función |
|------------|---------|
| ESP32 (Dev Board) | Cerebro del sistema — Bluetooth BLE, lógica de control |
| 2× Motor N20 con encoder | Tracción diferencial con odometría |
| TB6612FNG | Driver de motores de alta eficiencia |
| VL53L0X (ToF) | Detección de obstáculos por láser (±1 mm) |
| MPU-6050 | IMU — acelerómetro + giroscopio para navegación precisa |
| LiPo 2S 7.4V 2200mAh | Fuente de energía principal |
| Módulo Mini-360 | Regulador buck 7.4V → 5V |
| Módulo JESSINIE Tipo C | Carga integrada vía USB-C |
| Ruedas 43mm + ball casters | Sistema de rodadura (tracción diferencial) |
| Chasis impreso en 3D | Estructura diseñada a medida |

### Sistema de energía

```
Batería LiPo 2S (7.4V)
    │
    ├─── Interruptor ON/OFF
    │
    ├─── Fusible PPTC (protección contra cortocircuito)
    │
    ├─── Mini-360 Buck → 5V ──→ ESP32 + Sensores
    │
    └─── TB6612FNG ──────────→ Motores N20
```

---

## 📱 Funcionalidades

- **Control manual** desde app iOS nativa (Swift + CoreBluetooth)
- **Evasión autónoma** de obstáculos en tiempo real (prioridad sobre comando manual)
- **Giros precisos** de 90° y 180° mediante fusión sensorial encoder + IMU
- **Telemetría en vivo** en la app: distancia, velocidad, orientación, batería

---

## 🗂️ Estructura del Repositorio

```
/
├── firmware/          # Código fuente ESP32 (C++ / Arduino framework)
│   ├── src/
│   └── platformio.ini
├── ios-app/           # Aplicación iOS nativa en Swift
├── hardware/          # Esquemáticos y lista de materiales (BOM)
├── cad/               # Archivos del chasis 3D (.f3d / .stl)
├── docs/              # Documento técnico del proyecto por etapas
└── media/             # Fotos y videos de cada etapa
```

---

## 🚀 Etapas del Proyecto

- [x] Definición de objetivos y arquitectura del sistema
- [ ] **Etapa 1** — Control básico de motores (TB6612FNG + N20 + encoders)
- [ ] **Etapa 2** — Comunicación Bluetooth BLE (ESP32 ↔ iPhone)
- [ ] **Etapa 3** — Sensor ToF + lógica de evasión
- [ ] **Etapa 4** — IMU + fusión sensorial + giros precisos (PID)
- [ ] **Etapa 5** — Diseño e impresión del chasis 3D + integración final
- [ ] **Etapa 6** — Pruebas, métricas y documentación final

---

## 🧰 Stack Tecnológico

| Capa | Tecnología |
|------|-----------|
| Firmware | C++ / Arduino Framework (PlatformIO) |
| Comunicación | Bluetooth BLE (ESP32 ↔ CoreBluetooth) |
| App móvil | Swift (iOS nativo) |
| CAD | Fusion 360 |
| Documentación | Markdown + PDF |

---

## 👤 Autor

**Francisco David Zárate Vásquez: Ingeniero Mecatrónico** — Proyecto de desarrollo técnico personal que combina electrónica, mecánica, control de sistemas y desarrollo de software iOS.

---

## 📄 Licencia

MIT License — libre para usar, modificar y distribuir con atribución.
