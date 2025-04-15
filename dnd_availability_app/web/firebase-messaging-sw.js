// Required for Firebase Messaging
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyA2hHdz8fse7fMJP8ygu05LtPUDbAqPKVQ",
  authDomain: "'dispo-des-bros.firebaseapp.com'",
  projectId: "dispo-des-bros",
  messagingSenderId: "604239799472",
  appId: "1:604239799472:android:7162ed4aeaae3665c88775",
});

const messaging = firebase.messaging();