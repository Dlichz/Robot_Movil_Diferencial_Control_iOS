// Pines del Motor A
const int PWMA = 25;
const int AIN1 = 26;
const int AIN2 = 27;

// Pines del Motor B
const int BIN1 = 14;
const int BIN2 = 12;
const int PWMB = 33;

void setup() {
  // Configurar todos los pines como salida
  pinMode(PWMA, OUTPUT);
  pinMode(AIN1, OUTPUT);
  pinMode(AIN2, OUTPUT);
  pinMode(BIN1, OUTPUT);
  pinMode(BIN2, OUTPUT);
  pinMode(PWMB, OUTPUT);
}

void loop() {
  // Motor A - Girar adelante a velocidad media/alta
  digitalWrite(AIN1, HIGH);
  digitalWrite(AIN2, LOW);
  analogWrite(PWMA, 200); // Valor entre 0 y 255

  // Motor B - Girar adelante a velocidad media/alta
  digitalWrite(BIN1, HIGH);
  digitalWrite(BIN2, LOW);
  analogWrite(PWMB, 200); 

  delay(3000); // Girar por 3 segundos

  // Detener ambos motores
  digitalWrite(AIN1, LOW);
  digitalWrite(AIN2, LOW);
  digitalWrite(BIN1, LOW);
  digitalWrite(BIN2, LOW);
  
  delay(2000); // Esperar 2 segundos antes de repetir
}