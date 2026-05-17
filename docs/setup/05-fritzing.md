# 05 — Fritzing

> **Fritzing** es la herramienta para diseñar y documentar circuitos electrónicos. Lo usamos para crear los diagramas de conexión del robot.

---

## 🎯 ¿Qué es Fritzing?

Es un programa que permite:

- Diseñar circuitos en **vista de protoboard** (cómo se ven los cables reales)
- Generar **esquemáticos** (representación eléctrica formal)
- Diseñar **PCBs** (placas de circuito impreso)
- Exportar imágenes para documentación

Es muy usado en educación, hobby y prototipado rápido.

---

## 🆚 ¿Por qué Fritzing y no otro?

| Herramienta | Curva | Costo | Para qué |
|---|---|---|---|
| **Fritzing** | Baja | $8 USD (pago único) | Documentar circuitos visualmente |
| **KiCad** | Alta | Gratis | Diseñar PCBs profesionalmente |
| **EasyEDA** | Media | Gratis | PCBs (integrado con JLCPCB) |
| **TinkerCAD Circuits** | Muy baja | Gratis | Educación básica |
| **Altium Designer** | Muy alta | $$$ | Industria profesional |

**Fritzing** es la mejor opción para esta fase del proyecto:
- Vista de protoboard intuitiva
- Bueno para mostrar conexiones a otros
- Suficiente para validar el diseño antes de pasar a PCB

Cuando llegues a la etapa de PCB, migrarás a **KiCad** o **EasyEDA**.

---

## 📥 Instalación

### macOS

#### Opción 1: Versión oficial (pago)

1. Ve a https://fritzing.org/download/
2. Haz una donación (mínimo €8) para soportar el proyecto
3. Recibes un link de descarga al correo
4. Descarga el `.dmg`
5. Arrastra Fritzing a `Applications`

#### Opción 2: Versión gratuita antigua

Versiones más antiguas se encuentran en repositorios alternativos. **Funciona** pero tiene menos componentes y puede ser inestable en Mac con Apple Silicon.

### Linux

```bash
sudo apt install fritzing    # Ubuntu/Debian
sudo dnf install fritzing    # Fedora
```

### Windows

Igual que Mac, descarga el instalador de https://fritzing.org

---

## 🎨 Interfaz de Fritzing

Cuando abres un proyecto nuevo, ves esto:

```
┌─────────────────────────────────────────────────────────┐
│  Archivo  Editar  Vista  Parte  Ventana                  │
├─────────────────────────────────────────────────────────┤
│  [Breadboard]  [Schematic]  [PCB]                        │
├──────────────────────────────────┬──────────────────────┤
│                                  │                       │
│                                  │   Panel de            │
│       Área de trabajo            │   componentes        │
│       (aquí dibujas)             │                       │
│                                  │   CORE | MINE        │
│                                  │                       │
│                                  ├──────────────────────┤
│                                  │   Inspector          │
│                                  │   (propiedades del   │
│                                  │    componente        │
│                                  │    seleccionado)     │
│                                  │                       │
└──────────────────────────────────┴──────────────────────┘
```

### Las 3 vistas (pestañas arriba)

1. **Breadboard** — Vista realista con protoboard y cables. La más intuitiva.
2. **Schematic** — Esquemático eléctrico formal.
3. **PCB** — Diseño físico de placa de circuito impreso.

Las 3 vistas se actualizan automáticamente: si conectas algo en breadboard, aparece en las otras dos.

---

## 🧩 Componentes en Fritzing

### Las 3 pestañas del panel de componentes

- **CORE** — componentes incluidos por defecto (resistencias, LEDs, Arduino UNO, breadboard, etc.)
- **MINE** — componentes que importaste tú
- **All Parts** — todos juntos

### Componentes incluidos en este proyecto

Para evitar buscarlos uno por uno, este repo incluye los componentes custom en `hardware/fritzing-parts/`:

```
hardware/fritzing-parts/
├── ESP32_DevKit_V1.fzpz       # ESP32 DOIT 30 pines
├── TB6612FNG.fzpz             # Driver de motores
├── VL53L0X.fzpz               # Sensor ToF (Adafruit)
└── (otros si se agregan)
```

### Cómo importar componentes

#### Método 1: Drag & drop (recomendado)

1. Abre Finder y ve a `hardware/fritzing-parts/`
2. Tienes Fritzing abierto en otra ventana
3. **Arrastra los archivos `.fzpz`** sobre Fritzing
4. Aparecen en la pestaña **MINE**

#### Método 2: Menú

1. En Fritzing: **File → Open** (`Cmd + O`)
2. Selecciona el archivo `.fzpz`
3. Se importa automáticamente

---

## 🛠️ Operaciones básicas

### Atajos esenciales

| Acción | Atajo |
|---|---|
| Nuevo proyecto | `Cmd + N` |
| Guardar | `Cmd + S` |
| Acercar zoom | `Cmd + +` |
| Alejar zoom | `Cmd + -` |
| Ajustar a pantalla | `Cmd + 0` |
| Rotar componente 90° | Click derecho → Rotate 90° CW |
| Eliminar | Seleccionar + `Delete` |

### Cómo agregar un componente al área

1. Localiza el componente en el panel derecho (CORE o MINE)
2. **Click sostenido** y arrastra al área de trabajo
3. Suelta donde quieras colocarlo

### Cómo conectar componentes con cables

1. Click sostenido sobre el **círculo pequeño** de un pin
2. **Arrastra** hasta otro pin
3. Suelta cuando aparezca el indicador verde de conexión válida
4. Aparece un cable

### Cambiar color de cable

1. Click sobre el cable
2. En el **Inspector** (panel inferior derecho), busca el campo **color**
3. Selecciona el color deseado

### Doblar un cable

Click en algún punto intermedio del cable y arrastra para crear un "codo".

---

## 🎨 Convención de colores recomendada

Para mantener tus diagramas legibles:

| Función | Color | Por qué |
|---|---|---|
| GND (tierra) | Negro | Convención universal |
| 3.3V | Naranja | Diferenciar de 5V |
| 5V / VCC | Rojo | Convención |
| Batería + (7.4V) | Morado | Diferenciar de 5V |
| Señales digitales | Verde / Azul | Para datos |
| PWM | Amarillo | Para distinguir |
| Señales a motores | Blanco / Marrón | Output |

---

## 🔌 Cómo abrir el diagrama de este proyecto

Si ya hay un archivo `.fzz` en `hardware/`:

1. Abre Fritzing
2. **File → Open** (`Cmd + O`)
3. Navega a `hardware/motores-driver-esp32.fzz`
4. Click en **Open**

Si los componentes custom no aparecen, primero importa los `.fzpz` de `hardware/fritzing-parts/`.

---

## 📸 Exportar el diagrama como imagen

Para incluir en documentación o README:

1. **File → Export → as Image → PNG/SVG/PDF**
2. Selecciona resolución (300 dpi para impresión, 150 para web)
3. Guardar como `imagen.png`

Recomendado: exportar a **`docs/hardware/images/`** para usar en los `.md`.

---

## 🆘 Problemas comunes

### "Los componentes importados no aparecen en MINE"

**Solución:**
1. Cierra Fritzing
2. Vuelve a abrir
3. Importa los `.fzpz` nuevamente
4. Verifica en la pestaña **MINE**

### "Fritzing es muy lento en Apple Silicon (M1/M2/M3)"

Versiones antiguas de Fritzing no están optimizadas para chips ARM. Soluciones:

- Usar la versión oficial nueva (pagada)
- Reducir el zoom y simplificar el diagrama
- Cerrar otras aplicaciones para liberar RAM

### "Los cables se cruzan y el diagrama queda feo"

- Usa **codos** (click en mitad del cable + arrastrar)
- Mueve componentes con `arrastre` para mejor distribución
- Considera usar la vista **Schematic** que es más limpia para diagramas complejos

### "No encuentro un componente específico"

Si no está en CORE ni en MINE:
1. Busca en **https://github.com/sparkfun/Fritzing_Parts**
2. Busca en el foro: **https://forum.fritzing.org**
3. Descarga el `.fzpz` y arrástralo a Fritzing

### "Fritzing crashea al guardar"

Bug ocasional. Solución:
1. Guarda con **File → Save As** (no Save)
2. Da otro nombre temporal
3. Cierra y reabre

---

## 🚀 Cuando estés listo para PCB

Fritzing tiene vista PCB, pero no es ideal para producción real. Cuando llegues a fabricar un PCB:

1. Pásate a **KiCad** (gratis, profesional) o **EasyEDA** (online, fácil)
2. Re-dibuja el esquemático ahí
3. Diseña el ruteo del PCB
4. Exporta Gerbers
5. Manda a fabricar con **PCBWay** o **JLCPCB**

Fritzing es bueno para **documentar y validar conceptualmente**, pero para producción se usan herramientas más serias.

---

## ✅ Checklist al terminar

- [ ] Fritzing instalado
- [ ] Sé cambiar entre las 3 vistas (Breadboard, Schematic, PCB)
- [ ] Puedo importar componentes `.fzpz`
- [ ] Sé arrastrar componentes y conectar cables
- [ ] Sé exportar el diagrama como imagen

---

[← Anterior: Wokwi](04-wokwi.md) | [Siguiente: Git y GitHub →](06-git-github.md)
