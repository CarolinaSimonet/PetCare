
const admin = require("firebase-admin");
const fs = require("fs");
const express = require("express");
const bodyParser = require("body-parser");



console.log("Node.js is running");

// Replace 'path/to/serviceAccountKey.json' with the actual path to your service account key JSON file
const serviceAccount = require("./serviceAccountKey.json");

// Initialize the Firebase Admin SDK
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://scmu-10efc-default-rtdb.europe-west1.firebasedatabase.app/", // Replace with your database URL
});

console.log("Firebase Admin SDK initialized");

const db = admin.database();
const dbFS = admin.firestore();

console.log("Database initialized");

// Function to check data and send alerts
// async function checkDataAndSendAlert() {
//   try {
//     const snapshot = await db.ref("/fBowl1/cm").once("value");
//     const data = snapshot.val();
//     console.log("Data read successfully:", data);

//     if (data > 10) {
//       // Replace 'threshold' with your specific condition
//       console.log("Warning: Condition met!");

//       // Update the database to log the alert or send a notification
//       const alertRef = db.ref("/alerts");
//       await alertRef.push({
//         message: "Condition met!",
//         timestamp: admin.database.ServerValue.TIMESTAMP,
//       });

//       // Optional: Send a notification to Firebase Cloud Messaging (FCM)
//       const message = {
//         notification: {
//           title: "Alert",
//           body: "Condition met!",
//         },
//         topic: "alerts",
//       };

//       await admin.messaging().send(message);
//       console.log("Notification sent successfully");
//     } else {
//       console.log("Condition not met");
//     }
//   } catch (error) {
//     console.error("Error reading data:", error);
//   }
// }

async function turnLedOn() {
  console.log("LED turned on");
  // Add your logic to turn on the LED here
  try {
    const snapshot = await db.ref("/fireStatus").once("value");
    const data = snapshot.val();
    if (data == 0) {
      await db.ref("/fireStatus").set(1);
    } else {
      await db.ref("/fireStatus").set(0);
    }
  } catch (error) {
    console.error("Error updating fireStatus:", error);
  }
}

// // Schedule the function to run every minute
// setInterval(checkDataAndSendAlert, 10000); // 60000 ms = 1 minute

console.log("Server is running and checking data every minute");

// Set up Express server
const app = express();
app.use(bodyParser.json());

app.post("/turnOnLed", (req, res) => {
  turnLedOn();
  res.send({ message: "LED turned on" });
});

app.post("/assignRFID", async (req, res) => {
  const { userId } = req.body;

  if (!userId) {
    return res.status(400).send({ message: "userId is required" });
  }

  try {
    // 1. Get RFID from Database (Ensure it's unique)
    const rfidSnapshot = await db.ref(`/rfid/uid`).once("value");
    const rfid = rfidSnapshot.val();
    if (!rfid) {
      return res.status(500).send({ message: "No available RFID found" });
    }

    // 2. Check if User Exists
    const userSnapshot = await dbFS.collection("users").doc(userId).get();
    if (!userSnapshot.exists) {
      return res.status(404).send({ message: "User not found" });
    }

    // 3. Check if User Already Has RFID (Optional)
    const userData = userSnapshot.data();
    if (userData.rfid) {
      return res.status(400).send({ message: "User already has an RFID assigned" });
    }

    // 4. Assign RFID to User
    await dbFS.collection("users").doc(userId).update({ rfid });
    res.send({ message: `RFID ${rfid} assigned to user ${userId}` });

    // 5. (Optional) Mark RFID as Used in Database
    // await db.ref(`/rfid/uid`).remove(); // Or update a "used" flag

  } catch (error) {
    console.error("Error assigning RFID:", error);
    res.status(500).send({ message: "Internal Server Error" });
  }
});

// ... your other imports ...

// ... Firebase initialization ...

// Function to check if RFID is valid for a user
async function getRFIDValid(userId) {
  try {
    const userSnapshot = await dbFS.collection("users").doc(userId).get();

    if (!userSnapshot.exists) {
      return { valid: false, message: "User not found" };
    }

    const userData = userSnapshot.data();

    let rfidRT; // Declare rfidRT outside the loop
    let shouldContinue = true;
    let validRfid = false;
    const startTime = Date.now();
    const maxDuration = 30000; // 30 seconds

    while (!validRfid && shouldContinue) {
      // 1. Get RFID from Realtime Database
      const rfidSnapshot = await db.ref("/rfid/uid").once("value");
      rfidRT = rfidSnapshot.val(); // Assign value to rfidRT here
      console.log(rfidRT);
      
      // 2. Check if RFID matches and is not the default value (-1)
      if (rfidRT !== -1 && userData.rfid === rfidRT) {
        validRfid = true;
      }
      
      // 3. Break the loop if timeout is reached
      if (Date.now() - startTime > maxDuration || rfidRT != -1)  {
        shouldContinue = false;
      }
    }

    // Reset the RFID value in the database to -1
    await db.ref(`/rfid/uid`).set(-1);

    return validRfid ? { valid: true, message: "RFID valid" } : { valid: false, message: "Invalid RFID" };
  } catch (error) {
    console.error("Error processing RFID:", error);
    return { valid: false, message: "Error processing RFID" };
  }
}

// GET function for RFID validation
app.get("/getRFIDValid", async (req, res) => {
  const { userId } = req.query; // Use req.query for GET parameters

  if (!userId) {
    return res.status(400).send({ message: "userId is required" });
  }

  const result = await getRFIDValid(userId);
  if (result.valid) {
    // Send specific message to the Flutter app
    console.log("nice");
  } else {
    // Send error message to the Flutter app
    console.log("not nice");
  }

  res.send(result); // Send the result back to the Flutter app
});


const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Express server running on port ${PORT}`);
});
