#define sensorPower 33
#define sensorPin 32
int val = 0;

void setup() {
  pinMode(sensorPower, OUTPUT);
  digitalWrite(sensorPower, LOW);
  Serial.begin(19200);
}

void loop() {
  digitalWrite(sensorPower, HIGH);
  delay(10);
  val = analogRead(sensorPin);
  digitalWrite(sensorPower, LOW);
  Serial.print("Water level: ");
  Serial.println(val);
  delay(5000);
}