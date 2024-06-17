#include <Arduino.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include <SPI.h>
#include <MFRC522.h>

// Define the pins for the ultrasonic sensor
const int trigPinBowl1 = 22;
const int echoPinBowl1 = 21;
const int sensorPower = 33;
const int sensorPin = 32;

const int waterLed = 4;
const int foodLed = 2;

const int SS_PIN = 5;
const int RST_PIN = 26;
// Define sound speed in cm/uS
#define SOUND_SPEED 0.034
#define CM_TO_INCH 0.393701

// Firebase Realtime Database URL and API Key
#define WIFI_SSID "s22ujoao"
#define WIFI_PASSWORD "pila1231234"
#define API_KEY "AIzaSyAH2PKK19WBHAN19PZnL5NSG3N3uO4KZ6E"
#define DATABASE_URL "https://scmu-10efc-default-rtdb.europe-west1.firebasedatabase.app/" // Replace with your actual Firebase project URL

// Firebase objects
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
bool signupOK = false;

long duration;
float distanceCm;
float distanceInch;
unsigned long lastSensorReadTime = 0; // Timing control
unsigned long interval = 5000;        // 5 second in milliseconds

bool ledState = false;

// Class for the bowl of each pet
class SonicFoodBowl
{
private:
  byte trigPin;
  byte echoPin;
  byte id;

public:
  SonicFoodBowl()
  {
    // default constructor
  }

  SonicFoodBowl(byte trigPin, byte echoPin, byte id)
  {
    this->trigPin = trigPin;
    this->echoPin = echoPin;
    this->id = id;
  }

  void init()
  {
    pinMode(trigPin, OUTPUT);
    pinMode(echoPin, INPUT);
  }

  long sense()
  {
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

// Class for the water bowl of each pet
class WaterBowl
{

private:
  byte sensorPowerPin;
  byte sensorPin;
  byte id;
  long val;

public:
  WaterBowl()
  {
    // Default constructor
  }

  WaterBowl(byte sensorPowerPin, byte sensorPin, byte id)
  {
    this->sensorPowerPin = sensorPowerPin;
    this->sensorPin = sensorPin;
    this->id = id;
    val = 0;
  }

  void init()
  {
    pinMode(sensorPowerPin, OUTPUT);
    digitalWrite(sensorPowerPin, LOW);
  }

  long sense()
  {
    digitalWrite(sensorPowerPin, HIGH);
    delay(10);
    val = analogRead(sensorPin);
    digitalWrite(sensorPowerPin, LOW);
    Serial.print("Water level: ");
    Serial.println(val);
    return val;
  }
};

// Class for the RFID sensor
class RfidSensor
{
private:
  byte ss_pin;
  byte rst_pin;
  MFRC522 rfid; // Instance of the MFRC522 class
  MFRC522::MIFARE_Key key;

public:
  RfidSensor(byte ss_pin, byte rst_pin)
      : ss_pin(ss_pin), rst_pin(rst_pin), rfid(ss_pin, rst_pin)
  {
    // Constructor
  }

  void init()
  {
    SPI.begin();     // Init SPI bus
    rfid.PCD_Init(); // Init MFRC522

    for (byte i = 0; i < 6; i++)
    {
      key.keyByte[i] = 0xFF;
    }

    Serial.println(F("RFID sensor initialized."));
  }

  String readCard()
  {
    String uidString = ""; // Initialize an empty string to store the UID

    // Check if a new card is present
    if (!rfid.PICC_IsNewCardPresent())
    {
      Serial.println("No card present.");
      return uidString; // Return an empty string if no card is present
    }

    // Read the card's serial number
    if (!rfid.PICC_ReadCardSerial())
    {
      Serial.println("Error reading card.");
      return uidString; // Return an empty string if there's an error reading the card
    }

    // Process the card's data
    Serial.print(F("UID: "));
    for (byte i = 0; i < rfid.uid.size; i++)
    {
      uidString += String(rfid.uid.uidByte[i], HEX); // Append each byte of the UID to the string
    }
    Serial.println(uidString);

    return uidString; // Return the UID as a string
  }
};

// Instantiate WaterBowl object
WaterBowl wBowl1(sensorPower, sensorPin, 1);

// Bowl instances
SonicFoodBowl fBowl1(trigPinBowl1, echoPinBowl1, 1);

RfidSensor rfidSensor(SS_PIN, RST_PIN);

void setup()
{
  Serial.begin(115200);

  pinMode(waterLed, OUTPUT);
  pinMode(foodLed, OUTPUT);
  // Connect to Wi-Fi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
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
  if (Firebase.signUp(&config, &auth, "", ""))
  {
    Serial.println("Sign in Ok");
    signupOK = true;
  }
  else
  {
    Serial.printf("Sign up/sign in error: %s\n", config.signer.signupError.message.c_str());
  }

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  // Initialize bowl sensors
  fBowl1.init();
  wBowl1.init();
  rfidSensor.init();
}

void loop()
{
  unsigned long currentMillis = millis();

  long bowl1Distance = fBowl1.sense();
  long wBowlLevel = wBowl1.sense();


 
     // Fill water bowl and control LED
    if (wBowlLevel < 400 && !ledState)
    {                               // Check if bowl is not full AND LED is off
      digitalWrite(waterLed, HIGH); // Turn on LED to start dispensing water
      ledState = true;              // Update the LED state
    }
    else if (wBowlLevel >= 1500 && ledState)
    {                              // Check if bowl is full AND LED is on
      digitalWrite(waterLed, LOW); // Turn off LED to stop dispensing water
      ledState = false;            // Update the LED state
    }


  // Check fire status
  if (Firebase.ready() && signupOK)
  {
    if (Firebase.RTDB.getInt(&fbdo, "/dispenseFood"))
    {
      int dispenseFood = fbdo.intData();

      Serial.println(dispenseFood);
     
      if (dispenseFood == 1)
      {
        ledState = true;
        Serial.println("Dispense food");
        bowl1Distance = fBowl1.sense();
        digitalWrite(foodLed, HIGH);
      }
    }
    else
    {
      digitalWrite(foodLed, LOW);
    }
  }

  // Check if the current time is greater than the last read time plus the interval
  if (true)//currentMillis - lastSensorReadTime >= interval)
  {
    lastSensorReadTime = currentMillis;

    bowl1Distance = fBowl1.sense();
    wBowlLevel = wBowl1.sense();

 
    String uid = rfidSensor.readCard();

    // Check if the UID is not empty
    if (!uid.isEmpty())
    {
      // Send the UID to Firebase
      if (Firebase.ready() && signupOK)
      {
        Firebase.RTDB.setString(&fbdo, "/rfid/uid", uid);
      }
    }

    Serial.print("Bowl1 Distance (cm): ");
    Serial.println(bowl1Distance);

    if (Firebase.ready() && signupOK)
    {
      Firebase.RTDB.setFloat(&fbdo, "/fBowl1/cm", bowl1Distance);
      Firebase.RTDB.setFloat(&fbdo, "/wBowl1", wBowlLevel);
      Firebase.RTDB.setFloat(&fbdo, "/lastRfid", wBowlLevel);
    }
  }
}
