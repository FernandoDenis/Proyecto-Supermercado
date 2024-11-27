const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.listUsers = functions.https.onCall(async (data, context) => {
  try {
    const maxResults = 100; // Número máximo de usuarios a recuperar
    const listUsersResult = await admin.auth().listUsers(maxResults);
    const users = listUsersResult.users.map((userRecord) => {
      return {
        uid: userRecord.uid,
        email: userRecord.email,
        displayName: userRecord.displayName || "",
        photoURL: userRecord.photoURL || "",
      };
    });
    return { users };
  } catch (error) {
    throw new functions.https.HttpsError(
      "unknown",
      "Error al listar usuarios: " + error.message
    );
  }
});
