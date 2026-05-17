# 00. Introducción

## 1. Descripción del Proyecto

Este proyecto consiste en el diseño, construcción y programación de un robot móvil de tracción diferencial controlado de forma inalámbrica desde una aplicación iOS nativa. El sistema integra evasión autónoma de obstáculos, navegación precisa mediante fusión sensorial y telemetría en tiempo real visualizada desde un iPhone.

El proyecto combina disciplinas de electrónica, mecánica, control de sistemas y desarrollo de software móvil, representando una aplicación práctica completa de la ingeniería mecatrónica.

---

## 2. Motivación

La ingeniería mecatrónica integra mecánica, electrónica, control y programación. Sin embargo, pocas veces se tienen la oportunidad de aplicar todas estas áreas en un solo proyecto personal, fuera del entorno académico o laboral formal.

Este proyecto nace de la intención de poner a prueba esos conocimientos de forma autónoma, añadiendo además el desarrollo de una aplicación iOS nativa como diferenciador técnico. La combinación de un sistema embebido en ESP32 con una app desarrollada en Swift representa un stack tecnológico completo de extremo a extremo, desde el firmware hasta la interfaz de usuario.

---

## 3. Objetivo General

Diseñar, construir y programar un robot móvil de tracción diferencial controlado de forma inalámbrica desde una aplicación iOS nativa, integrando evasión autónoma de obstáculos, navegación precisa y telemetría en tiempo real.

---

## 4. Objetivos Específicos

### 4.1 Hardware y Sistema de Energía
Implementar un sistema electrónico funcional basado en ESP32, con driver TB6612FNG, motores N20 con encoder y alimentación LiPo 2S regulada y protegida mediante fusible PPTC y módulo buck Mini-360.

**Criterio de éxito:** Sistema energizado y estable sin sobrecalentamiento durante operación continua.

### 4.2 Control de Movimiento Preciso
Lograr giros de 90° y 180° con error promedio menor a 5°, mediante un controlador PID que fusiona la información de los encoders de los motores N20 y el giroscopio del MPU-6050.

**Criterio de éxito:** Error promedio < 5° en 10 giros consecutivos de cada ángulo.

### 4.3 Evasión Autónoma de Obstáculos
Implementar un comportamiento reactivo que detecte obstáculos mediante el sensor ToF VL53L0X a una distancia menor o igual a 20 cm, ejecutando una maniobra de evasión en menos de 500 ms con prioridad sobre cualquier comando manual.

**Criterio de éxito:** Cero colisiones en 10 pruebas consecutivas con obstáculos a ≤ 20 cm.

### 4.4 Control Remoto desde iPhone
Desarrollar una aplicación iOS nativa en Swift que se comunique con el ESP32 mediante Bluetooth BLE (CoreBluetooth) para enviar comandos de movimiento en tiempo real.

**Criterio de éxito:** Latencia de respuesta menor a 100 ms desde la interacción en la app hasta la respuesta del robot.

### 4.5 Telemetría en Tiempo Real
Visualizar en la app iOS datos del robot actualizados en vivo: distancia al obstáculo más cercano, velocidad estimada, orientación (yaw) y nivel de batería.

**Criterio de éxito:** Datos actualizados cada ≤ 200 ms sin pérdida de conexión en operación normal.

### 4.6 Chasis Diseñado a Medida
Diseñar e imprimir en 3D un chasis que integre todos los componentes de forma ordenada, accesible para mantenimiento y sin cables sueltos.

**Criterio de éxito:** Todos los componentes fijos y desmontables sin necesidad de herramientas especiales.

---

## 5. Alcances

- El robot opera en superficies planas de interiores (escritorio, mesa).
- El control remoto funciona dentro del rango Bluetooth BLE (aproximadamente 10 metros en interiores).
- La evasión de obstáculos es reactiva, no predictiva — el robot responde al obstáculo cuando lo detecta, no planifica rutas.
- La app iOS es compatible con iPhone (iOS 16 en adelante).
- El sistema de carga es integrado mediante puerto USB-C.

---

## 6. Limitaciones

- No se implementa navegación autónoma completa ni mapeo del entorno (SLAM).
- El robot no está diseñado para superficies irregulares, rampas o exteriores.
- La app no incluye modo multijugador ni control desde múltiples dispositivos simultáneamente.
- La precisión de la odometría puede degradarse en superficies con poca fricción.

---

## 7. Estructura del Documento

| Capítulo | Contenido |
|----------|-----------|
| 00. Introducción | Este documento — contexto, objetivos, alcances |
| 01. Marco Teórico | Fundamentos técnicos de cada subsistema |
| 02. Diseño de Hardware | Componentes, esquemáticos, sistema de energía, chasis |
| 03. Diseño de Firmware | Arquitectura de software del ESP32, PID, BLE |
| 04. Aplicación iOS | Arquitectura de la app, CoreBluetooth, telemetría |
| 05. Pruebas y Resultados | Métricas reales, tablas, gráficas comparativas |
| 06. Conclusiones | Logros, problemas resueltos, trabajo futuro |

---

*Última actualización: Mayo 2026*