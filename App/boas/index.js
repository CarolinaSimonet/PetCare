
// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendAlert = functions.database.ref("/fBowl1/cm")
    .onUpdate((change, context) => {
      const newValue = change.after.val();
      if (newValue < 10) { // Check if distance is less than 10 cm
        const alertMessage = {
          data: {
            title: "Alert",
            body: "Object too close!",
          },
          topic: "alerts",
        };

        // Send a message to devices subscribed to the "alerts" topic.
        return admin.messaging().send(alertMessage)
            .then((response) => {
              console.log("Successfully sent message:", response);
              return null;
            })
            .catch((error) => {
              console.log("Error sending message:", error);
            });
      }
      return null;
    });
/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
