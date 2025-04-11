const { google } = require("google-auth-library");
const fetch = require("node-fetch");
const serviceAccount = require("D:/source/dispo-des-bros-firebase-adminsdk-fbsvc-be182062a8.json"); // nom exact du fichier téléchargé

const SCOPES = ["https://www.googleapis.com/auth/firebase.messaging"];
const FCM_ENDPOINT = `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`;

async function getAccessToken() {
  const client = new google.auth.JWT(
    serviceAccount.client_email,
    null,
    serviceAccount.private_key,
    SCOPES,
    null
  );
  const tokens = await client.authorize();
  return tokens.access_token;
}

async function sendNotification() {
  const token = await getAccessToken();

  const message = {
    message: {
      topic: "weekly-reminder",
      notification: {
        title: "📅 Rappel DnD",
        body: "Pense à renseigner tes disponibilités pour cette semaine !",
      },
    },
  };

  const response = await fetch(FCM_ENDPOINT, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify(message),
  });

  const data = await response.json();
  if (!response.ok) {
    console.error("❌ Erreur d'envoi :", data);
  } else {
    console.log("✅ Notification envoyée :", data);
  }
}

sendNotification().catch(console.error);
