const admin = require("firebase-admin");
const functions = require("firebase-functions");

admin.initializeApp();

const messaging = admin.messaging();

// eslint-disable-next-line max-len
exports.notifySubscribers = functions.https.onCall(async (data, _) => {
  try {
    await messaging.sendToDevice(data.targetDevices, {
      notification: {
        title: data.messageTitle,
        body: data.messageBody,
      },
    //   data: {
    //     key1: data.value1,
    //     key2: data.value2,
    //     key3: data.value3,
    //   },
    });
    return true;
  } catch (ex) {
    return false;
  }
});
