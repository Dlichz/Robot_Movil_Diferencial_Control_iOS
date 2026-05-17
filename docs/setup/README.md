# Guías de Configuración del Entorno

> Esta sección documenta **paso a paso** cómo configurar todas las herramientas necesarias para trabajar en este proyecto desde cero. Si descargaste el repositorio y no sabes por dónde empezar, este es tu punto de partida.

---

## 🎯 Para quién es esta documentación

- Quien clona el repositorio por primera vez
- Quien quiere replicar el entorno de desarrollo
- Quien necesita reinstalar todo tras un cambio de equipo
- Quien quiere entender el "por qué" detrás de cada herramienta

---

## 📋 Orden recomendado de lectura

1. **[Prerrequisitos](01-prerequisitos.md)** — Sistema operativo, hardware y cuentas necesarias
2. **[VS Code](02-vscode.md)** — Editor de código principal
3. **[PlatformIO](03-platformio.md)** — Sistema de build para microcontroladores
4. **[Wokwi](04-wokwi.md)** — Simulador electrónico
5. **[Fritzing](05-fritzing.md)** — Diseño de circuitos
6. **[Git y GitHub](06-git-github.md)** — Versionamiento de código
7. **[Flashear el ESP32](07-flashear-esp32.md)** — Cargar código en hardware real

---

## ⏱️ Tiempo estimado

| Etapa | Tiempo |
|---|---|
| Setup completo desde cero | 1-2 horas |
| Setup mínimo (solo firmware) | 30-45 min |
| Reinstalar todo | 45 min |

---

## 🖥️ Sistema operativo soportado

Este proyecto se desarrolló en **macOS**. Las guías están optimizadas para Mac (Intel y Apple Silicon).

Para Linux o Windows, los pasos son similares pero los comandos varían. Las herramientas (VS Code, PlatformIO, Wokwi, Fritzing) son multiplataforma.

---

## 🆘 Solución de problemas comunes

Cada guía incluye al final una sección de **"Problemas comunes"** con los errores típicos y sus soluciones.

Si encuentras un problema nuevo, agrégalo a la guía correspondiente para que otros se beneficien.

---

## 📁 Estructura del repositorio (referencia)

```
Robot diferencial iOS/
├── cad/                    # Diseños 3D del chasis
├── docs/                   # Documentación (estás aquí)
│   ├── setup/              # Guías de instalación
│   ├── hardware/           # Documentación de componentes
│   ├── firmware/           # Arquitectura del código
│   └── bitacoras/          # Diario de desarrollo
├── firmware/
│   └── esp32/              # Proyecto PlatformIO
│       ├── src/main.cpp
│       ├── platformio.ini
│       ├── diagram.json    # Wokwi
│       └── wokwi.toml
├── hardware/
│   ├── fritzing-parts/     # Componentes custom de Fritzing
│   └── *.fzz               # Diagramas de circuito
├── ios-app/                # App iOS (futuro)
├── media/                  # Fotos y videos
└── simulation/             # Archivos auxiliares de simulación
```

---

*Documentación mantenida por: David Zárate*
*Última actualización: mayo 2026*
