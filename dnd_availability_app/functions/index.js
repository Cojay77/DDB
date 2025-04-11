const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendWeeklyReminder = functions.pubsub
    .schedule("every sunday 16:00")
    .timeZone("Europe/Paris")
    .onRun(async (context) => {
      await admin.messaging().send({
        topic: "weekly-reminder",
        notification: {
          title: "📅 Rappel DnD",
          body:
              "Pense à renseigner tes disponibilités pour cette semaine !",
        },
      });

      console.log("✅ Notification hebdomadaire envoyée.");
    });
