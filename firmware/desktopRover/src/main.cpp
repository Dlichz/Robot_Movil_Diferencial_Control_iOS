#include <Arduino.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

// ===== UUIDs Nordic UART Service (NUS) =====
#define SERVICE_UUID "6e400001-b5a3-f393-e0a9-e50e24dcca9e"
#define CHARACTERISTIC_RX "6e400002-b5a3-f393-e0a9-e50e24dcca9e" // iPhone -> ESP32
#define CHARACTERISTIC_TX "6e400003-b5a3-f393-e0a9-e50e24dcca9e" // ESP32 -> iPhone

#define DEVICE_NAME "DesktopRover"
#define LED_PIN 2 // LED interno del ESP32 DevKit

BLEServer *pServer = nullptr;
BLECharacteristic *pTxCharacteristic = nullptr;
bool deviceConnected = false;
bool oldDeviceConnected = false;

// ===== Helper para enviar respuestas =====
void sendResponse(const String &msg)
{
  if (deviceConnected && pTxCharacteristic)
  {
    pTxCharacteristic->setValue(msg.c_str());
    pTxCharacteristic->notify();
    Serial.printf("[TX] %s\n", msg.c_str());
  }
}

// ===== Callbacks de conexión =====
class ServerCallbacks : public BLEServerCallbacks
{
  void onConnect(BLEServer *pServer) override
  {
    deviceConnected = true;
    Serial.println("[BLE] Cliente conectado");
  }

  void onDisconnect(BLEServer *pServer) override
  {
    deviceConnected = false;
    Serial.println("[BLE] Cliente desconectado");
  }
};

// ===== Callback de comandos recibidos =====
class RxCallbacks : public BLECharacteristicCallbacks
{
  void onWrite(BLECharacteristic *pCharacteristic) override
  {
    String value = pCharacteristic->getValue().c_str();
    value.trim();

    if (value.length() == 0)
      return;

    Serial.printf("[RX] %s\n", value.c_str());

    // Procesar comandos
    if (value == "PING")
    {
      sendResponse("PONG");
    }
    else if (value == "LED_ON")
    {
      digitalWrite(LED_PIN, HIGH);
      sendResponse("LED:1");
    }
    else if (value == "LED_OFF")
    {
      digitalWrite(LED_PIN, LOW);
      sendResponse("LED:0");
    }
    else if (value == "STATUS")
    {
      String resp = "OK,uptime=" + String(millis() / 1000);
      sendResponse(resp);
    }
    else
    {
      sendResponse("ERR:UNKNOWN_CMD");
    }
  }
};

void setup()
{
  Serial.begin(115200);
  delay(500);
  Serial.println("\n=== DesktopRover BLE iniciando ===");

  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, LOW);

  // Inicializar BLE
  BLEDevice::init(DEVICE_NAME);

  // Crear servidor
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new ServerCallbacks());

  // Crear servicio
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Characteristic TX (ESP32 -> iPhone) con notify
  pTxCharacteristic = pService->createCharacteristic(
      CHARACTERISTIC_TX,
      BLECharacteristic::PROPERTY_NOTIFY);
  pTxCharacteristic->addDescriptor(new BLE2902());

  // Characteristic RX (iPhone -> ESP32) con write
  BLECharacteristic *pRxCharacteristic = pService->createCharacteristic(
      CHARACTERISTIC_RX,
      BLECharacteristic::PROPERTY_WRITE | BLECharacteristic::PROPERTY_WRITE_NR);
  pRxCharacteristic->setCallbacks(new RxCallbacks());

  // Iniciar servicio
  pService->start();

  // Iniciar advertising
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06); // mejor compatibilidad con iPhone
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();

  Serial.printf("[BLE] Advertising como '%s'\n", DEVICE_NAME);
  Serial.println("[BLE] Esperando conexión del iPhone...");
}

void loop()
{
  // Re-iniciar advertising tras desconexión
  if (!deviceConnected && oldDeviceConnected)
  {
    delay(500);
    pServer->startAdvertising();
    Serial.println("[BLE] Re-advertising");
    oldDeviceConnected = deviceConnected;
  }
  if (deviceConnected && !oldDeviceConnected)
  {
    oldDeviceConnected = deviceConnected;
  }

  // Telemetría de prueba cada 2 segundos
  static uint32_t lastTelemetry = 0;
  if (deviceConnected && millis() - lastTelemetry > 2000)
  {
    lastTelemetry = millis();
    String t = "HEARTBEAT," + String(millis());
    sendResponse(t);
  }

  delay(10);
}