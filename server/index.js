
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

let lastEmptyTime = null;


async function checkDataAndSendAlert() {
  try {
    const snapshot = await db.ref("/fBowl1/cm").once("value");
    const data = snapshot.val();
    console.log("Data read successfully:", data);

    if (data >= 50) { // Empty bowl condition
      if (lastEmptyTime === null) {
        lastEmptyTime = Date.now();
      } else {
        const elapsedTime = Date.now() - lastEmptyTime;
        if (elapsedTime >= 30000) { // 30 seconds have passed
          console.log("Warning: Food bowl empty for 30 seconds!");
          sendNotification();
          // ... (send notification logic)
          lastEmptyTime = null; // Reset timer after sending the notification
        }
      }
    } else {
      lastEmptyTime = null; // Reset timer if bowl is refilled
    }
  } catch (error) {
    console.error("Error reading data:", error);
  }
}

async function sendNotificationToAllUsers(message) {
  try {
    const usersSnapshot = await dbFS.collection("users").get();
    const notificationPromises = [];

    usersSnapshot.forEach((doc) => {
      const userData = doc.data();
      const fcmToken = userData.fcmToken;

      if (fcmToken) {
        const notificationMessage = {
          data: {
            title: "Food Bowl Alert",
            body: message,
          },
          token: fcmToken,
        };

        notificationPromises.push(admin.messaging().send(notificationMessage));
      } else {
        console.warn(`FCM token not found for user ${doc.id}`);
      }
    });

    await Promise.all(notificationPromises);
    console.log("Notifications sent successfully");
  } catch (error) {
    console.error("Error sending notifications:", error);
  }
} 

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

app.get("/assignRFID", async (req, res) => {
  const { userId } = req.query;

  if (!userId) {
    return res.status(400).send({ message: "userId is required" });
  }

  try {
    // 1. Check if User Exists
    const userSnapshot = await dbFS.collection("users").doc(userId).get();
    if (!userSnapshot.exists) {
      return res.status(404).send({ message: "User not found" });
    }

    const userData = userSnapshot.data();
    const fcmToken = userData.fcmToken;

    if (!fcmToken) {
      return res.status(400).send({ message: "User FCM token not found" });
    }

    // 2. Wait for RFID Read (with timeout)
    let rfidRT; // Declare rfidRT outside the loop
    let shouldContinue = true;
    const startTime = Date.now();
    const maxDuration = 30000; // 30 seconds

    while (shouldContinue) {
      // 1. Get RFID from Realtime Database
      const rfidSnapshot = await db.ref("/rfid/uid").once("value");
      rfidRT = rfidSnapshot.val(); // Assign value to rfidRT here
      console.log(rfidRT);

      // 2. Check if RFID is not the default value (-1)
      if (rfidRT !== -1) {
        shouldContinue = false; // Stop the loop if RFID is read
      }

      // 3. Break the loop if timeout is reached
      if (Date.now() - startTime > maxDuration) {
        shouldContinue = false;
      }
    }

    await db.ref(`/rfid/uid`).set(-1);

    // 3. Assign RFID or Handle Errors

    if (rfidRT !== -1) { // RFID was read successfully

      // 3. Check if User Already Has RFID (Optional)

      // 4. Assign RFID to User
      await dbFS.collection("users").doc(userId).update({ rfid: rfidRT });
      // 5. Send Success FCM Notification
      // const message = {
      //   data: {
      //     action: "RFID_ASSIGNED",
      //     id: userId,
      //     title: "RFID Assigned",
      //     body: `RFID ${rfidRT} was successfully assigned.`,
      //   },
      //   token: fcmToken,
      // };


      // await admin.messaging().send(message);

      return res.status(200).send({ message: `RFID ${rfidRT} assigned to user ${userId}` });

    } else { // Timeout or error occurred
      // 6. Send Error FCM Notification (optional)
      const errorMessage = "RFID assignment timed out or failed.";
      const message = {
        data: {
          action: "RFID_ASSIGN_ERROR",
          title: "RFID Assignment Error",
          body: errorMessage,
        },
        token: fcmToken,
      };

      await admin.messaging().send(message);
      res.status(500).send({ message: errorMessage }); // Or a more specific error code
    }

    // Reset the RFID value in the database to -1
    await db.ref(`/rfid/uid`).set(-1);

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
      if (Date.now() - startTime > maxDuration || rfidRT != -1) {
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

app.get("/getRFIDValid", async (req, res) => {
  const { userId } = req.query;

  if (!userId) {
    return res.status(400).send({ message: "userId is required" });
  }

  const result = await getRFIDValid(userId);

  try {
    // Fetch user document and get FCM token
    const userSnapshot = await dbFS.collection("users").doc(userId).get();

    if (!userSnapshot.exists) {
      return res.status(404).send({ message: "User not found" });
    }

    const userData = userSnapshot.data();
    const fcmToken = userData.fcmToken;

    if (!fcmToken) {
      return res.status(400).send({ message: "User FCM token not found" });
    }

    if (result.valid) {
      const message = {
        data: {
          action: "RFID_READ",
          id: userId,
          title: "RFID Read Successful",
          body: "Your RFID was read successfully.",
        },
        token: fcmToken, // Send the message to the fetched token
      };

      await admin.messaging().send(message);
      console.log("nice");
    } else {
      console.log("not nice");
    }
  } catch (error) {
    console.error("Error sending FCM notification:", error);
    res.status(500).send({ message: "Internal server error" }); // Added error handling
  }

  res.send(result); // Send the result back to the Flutter app
});

app.get("/getWaterBowl", async (req, res) => {

  try {
    const snapshot = await db.ref("/wBowl1").once("value");
    const data = snapshot.val();
    console.log("Data read successfully:", data);
    res.send(data);
  } catch (error) {
    console.error("Error reading data:", error);
    res.status(500).send({ message: error });
  }
});

app.get("/getFoodBowl", async (req, res) => {
  try {
    const snapshot = await db.ref("/fBowl1").once("value");
    const data = snapshot.val();
    console.log("Data read successfully:", data);
    res.send(data);
  } catch (error) {
    console.error("Error reading data:", error);
    res.status(500).send({ message: "Internal server error" });
  }
});



const PORT = process.env.PORT || 8080;
// app.listen(PORT, () => {
//   console.log(`Express server running on port ${PORT}`);
// });

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running at http://0.0.0.0:${PORT}/`);
});

