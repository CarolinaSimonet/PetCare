#include <Arduino.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h>

// Define the pins for the ultrasonic sensor
const int trigPinBowl1 = 19;
const int echoPinBowl1 = 21;

// Define sound speed in cm/uS
#define SOUND_SPEED 0.034
#define CM_TO_INCH 0.393701

// Firebase Realtime Database URL and API Key
#define WIFI_SSID "s22ujoao"
#define WIFI_PASSWORD "pila1231234"
#define API_KEY "AIzaSyAH2PKK19WBHAN19PZnL5NSG3N3uO4KZ6E"
#define DATABASE_URL "https://scmu-10efc-default-rtdb.europe-west1.firebasedatabase.app/"

// Firebase objects
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
bool signupOK = false;

long duration;
float distanceCm;
float distanceInch;
unsigned long lastSensorReadTime = 0; // Timing control
unsigned long interval = 1000; // 1 second in milliseconds

// Class for the bowl of each pet
class SonicFoodBowl {
private:
  byte trigPin;
  byte echoPin;
  byte id;

public:
  SonicFoodBowl() {
    //default constructor
  }

  SonicFoodBowl(byte trigPin, byte echoPin, byte id) {
    this->trigPin = trigPin;
    this->echoPin = echoPin;
    this->id = id;
  }

  void init() {
    pinMode(trigPin, OUTPUT);
    pinMode(echoPin, INPUT);
  }

  long sense() {
    // Clear the trigPin
    digitalWrite(trigPin, LOW);
    delayMicroseconds(2);
    digitalWrite(trigPin, HIGH);
    delayMicroseconds(10);
    digitalWrite(trigPin, LOW);

    // Read the echoPin
    duration = pulseIn(echoPin, HIGH);

    // Calculate the distance
    distanceCm = duration * SOUND_SPEED / 2;
    return distanceCm;
  }
};

// Bowl instances
SonicFoodBowl bowl1(trigPinBowl1, echoPinBowl1, 1);

void setup() {
  Serial.begin(115200);

  // Connect to Wi-Fi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  // Firebase configuration
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;

  // Sign up or sign in to Firebase
  if (Firebase.signUp(&config, &auth, "", "")) {
    Serial.println("Sign in Ok");
    signupOK = true;
  } else {
    Serial.printf("Sign up/sign in error: %s\n", config.signer.signupError.message.c_str());
  }

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  // Initialize bowl sensors
  bowl1.init();
}

void loop() {
  unsigned long currentMillis = millis();

  // Check if the current time is greater than the last read time plus the interval
  if (currentMillis - lastSensorReadTime >= interval) {
    lastSensorReadTime = currentMillis;

    long bowl1Distance = bowl1.sense();

    Serial.print("Bowl1 Distance (cm): ");
    Serial.println(bowl1Distance);

    if (Firebase.ready() && signupOK) {
      Firebase.RTDB.setFloat(&fbdo, "/bowl1/cm", bowl1Distance);
    }
  }

  delay(1000);
}
