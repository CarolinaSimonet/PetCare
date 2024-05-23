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
