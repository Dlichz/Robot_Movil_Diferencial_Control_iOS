#include <Arduino.h>

// ============================================================
//  Robot Diferencial ESP32 - Control de Motores
//  Etapa 1: Driver de motores (TB6612FNG / L298N stand-in)
// ============================================================

// ---------- PINES MOTOR A (Izquierdo) ----------
#define PWMA 25
#define AIN1 26
#define AIN2 27

// ---------- PINES MOTOR B (Derecho) ----------
#define PWMB 33
#define BIN1 14
#define BIN2 12

// ---------- STBY (solo TB6612 real) ----------
#define STBY 13

// ---------- LEDs indicadores ----------
#define LED_FWD 2
#define LED_BWD 4

// ---------- CONFIGURACION PWM (ESP32 LEDC) ----------
const int FREQ_PWM = 1000;
const int RES_PWM = 8;
const int CANAL_PWMA = 0;
const int CANAL_PWMB = 1;

int velocidad = 200;

// ---------- DECLARACION DE FUNCIONES ----------
void motorA(int vel);
void motorB(int vel);
void adelante();
void atras();
void girarIzquierda();
void girarDerecha();
void detener();

// ============================================================
//  SETUP
// ============================================================
void setup()
{
  Serial.begin(115200);
  delay(500);
  Serial.println("\n=== Robot Diferencial ESP32 - Test Motores ===");

  pinMode(AIN1, OUTPUT);
  pinMode(AIN2, OUTPUT);
  pinMode(BIN1, OUTPUT);
  pinMode(BIN2, OUTPUT);
  pinMode(STBY, OUTPUT);
  pinMode(LED_FWD, OUTPUT);
  pinMode(LED_BWD, OUTPUT);

  ledcSetup(CANAL_PWMA, FREQ_PWM, RES_PWM);
  ledcSetup(CANAL_PWMB, FREQ_PWM, RES_PWM);
  ledcAttachPin(PWMA, CANAL_PWMA);
  ledcAttachPin(PWMB, CANAL_PWMB);

  digitalWrite(STBY, HIGH);

  Serial.println("Comandos disponibles:");
  Serial.println("  w = adelante   s = atras");
  Serial.println("  a = girar izq  d = girar der");
  Serial.println("  x = detener");
  Serial.println("  + = mas rapido - = mas lento");

  detener();
}

// ============================================================
//  FUNCIONES DE MOVIMIENTO
// ============================================================
void motorA(int vel)
{
  if (vel >= 0)
  {
    digitalWrite(AIN1, HIGH);
    digitalWrite(AIN2, LOW);
    ledcWrite(CANAL_PWMA, vel);
  }
  else
  {
    digitalWrite(AIN1, LOW);
    digitalWrite(AIN2, HIGH);
    ledcWrite(CANAL_PWMA, -vel);
  }
}

void motorB(int vel)
{
  if (vel >= 0)
  {
    digitalWrite(BIN1, HIGH);
    digitalWrite(BIN2, LOW);
    ledcWrite(CANAL_PWMB, vel);
  }
  else
  {
    digitalWrite(BIN1, LOW);
    digitalWrite(BIN2, HIGH);
    ledcWrite(CANAL_PWMB, -vel);
  }
}

void adelante()
{
  motorA(velocidad);
  motorB(velocidad);
  digitalWrite(LED_FWD, HIGH);
  digitalWrite(LED_BWD, LOW);
  Serial.println(">> ADELANTE");
}

void atras()
{
  motorA(-velocidad);
  motorB(-velocidad);
  digitalWrite(LED_FWD, LOW);
  digitalWrite(LED_BWD, HIGH);
  Serial.println(">> ATRAS");
}

void girarIzquierda()
{
  motorA(-velocidad);
  motorB(velocidad);
  digitalWrite(LED_FWD, HIGH);
  digitalWrite(LED_BWD, HIGH);
  Serial.println(">> GIRO IZQUIERDA");
}

void girarDerecha()
{
  motorA(velocidad);
  motorB(-velocidad);
  digitalWrite(LED_FWD, HIGH);
  digitalWrite(LED_BWD, HIGH);
  Serial.println(">> GIRO DERECHA");
}

void detener()
{
  motorA(0);
  motorB(0);
  digitalWrite(LED_FWD, LOW);
  digitalWrite(LED_BWD, LOW);
  Serial.println(">> DETENIDO");
}

// ============================================================
//  LOOP PRINCIPAL
// ============================================================
void loop()
{
  if (Serial.available())
  {
    char c = Serial.read();
    switch (c)
    {
    case 'w':
      adelante();
      break;
    case 's':
      atras();
      break;
    case 'a':
      girarIzquierda();
      break;
    case 'd':
      girarDerecha();
      break;
    case 'x':
      detener();
      break;
    case '+':
      velocidad = min(255, velocidad + 20);
      Serial.print("Velocidad: ");
      Serial.println(velocidad);
      break;
    case '-':
      velocidad = max(0, velocidad - 20);
      Serial.print("Velocidad: ");
      Serial.println(velocidad);
      break;
    }
  }
}