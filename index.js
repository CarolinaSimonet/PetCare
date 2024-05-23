const admin = require("firebase-admin");
const fs = require("fs");

console.log("Node.js is running");

// Replace 'path/to/serviceAccountKey.json' with the actual path to your service account key JSON file
const serviceAccount = require("./serviceAccountKey.json");

// Initialize the Firebase Admin SDK
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL:
    "https://scmu-10efc-default-rtdb.europe-west1.firebasedatabase.app/", // Replace with your database URL
});

console.log("Firebase Admin SDK initialized");

const db = admin.database();

console.log("Database initialized");

// Function to check data and send alerts
async function checkDataAndSendAlert() {
  try {
    const snapshot = await db.ref("/fBowl1/cm").once("value");
    const data = snapshot.val();
    console.log("Data read successfully:", data);

    if (data > 10) {
      // Replace 'threshold' with your specific condition
      console.log("Warning: Condition met!");

      // Update the database to log the alert or send a notification
      const alertRef = db.ref("/alerts");
      await alertRef.push({
        message: "Condition met!",
        timestamp: admin.database.ServerValue.TIMESTAMP,
      });

      // Optional: Send a notification to Firebase Cloud Messaging (FCM)
      const message = {
        notification: {
          title: "Alert",
          body: "Condition met!",
        },
        topic: "alerts",
      };

      await admin.messaging().send(message);
      console.log("Notification sent successfully");
    } else {
      console.log("Condition not met");
    }
  } catch (error) {
    console.error("Error reading data:", error);
  }
}

// Schedule the function to run every minute
setInterval(checkDataAndSendAlert, 10000); // 60000 ms = 1 minute

console.log("Server is running and checking data every minute");
