#include <Arduino.h>
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>

#define SERVICE_UUID "4FAFC201-1FB5-459E-8FCC-C5C9C331914B"
#define CHARACTERISTIC_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26A8"

// Define el pin del LED interno (en la mayoría de ESP32 es el pin 2)
const int ledPin = 2;

// Clase que maneja los eventos de escritura desde la App
class MyCharacteristicCallbacks : public BLECharacteristicCallbacks
{
  void onWrite(BLECharacteristic *pCharacteristic)
  {
    std::string value = pCharacteristic->getValue();

    if (value.length() > 0)
    {
      Serial.print("Dato recibido: ");
      for (int i = 0; i < value.length(); i++)
      {
        Serial.print(value[i]);
      }
      Serial.println();

      // Si recibimos un '1', encendemos el LED. Si es '0', lo apagamos.
      if (value == "1")
      {
        digitalWrite(ledPin, HIGH);
        Serial.println("LED Encendido");
      }
      else if (value == "0")
      {
        digitalWrite(ledPin, LOW);
        Serial.println("LED Apagado");
      }
    }
  }
};

void setup()
{
  Serial.begin(115200);

  // Configura el pin del LED como salida
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW); // Arranca apagado

  Serial.println("Iniciando ESP32 BLE...");
  BLEDevice::init("ESP32_LED_Control");

  BLEServer *pServer = BLEDevice::createServer();
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // AHORA AÑADIMOS PROPERTY_WRITE para poder recibir datos desde el iPhone
  BLECharacteristic *pCharacteristic = pService->createCharacteristic(
      CHARACTERISTIC_UUID,
      BLECharacteristic::PROPERTY_READ |
          BLECharacteristic::PROPERTY_WRITE |
          BLECharacteristic::PROPERTY_NOTIFY);

  // Asignamos las funciones callback a la característica
  pCharacteristic->setCallbacks(new MyCharacteristicCallbacks());
  pCharacteristic->setValue("0"); // Estado inicial

  pService->start();

  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);
  BLEDevice::startAdvertising();

  Serial.println("¡Listo! Esperando comandos del iPhone...");
}

void loop()
{
  delay(2000);
}