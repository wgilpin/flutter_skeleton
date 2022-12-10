import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {firestore} from "firebase-admin";

let config = {};

if (process.env.ENVIRONMENT === "local") {
  const projectId = "XXX";
  config = {
    projectId: projectId,
    databaseURL: `http://localhost:8080/?ns=${projectId}`,
  };
}
admin.initializeApp(config);

// admin.auth;
// import firebase from "firebase/app";

// admin.functions().useEmulator("localhost", 5001);
// const db = firebase.firestore();
// if (location.hostname === "localhost") {
//   db.useEmulator("localhost", 8080);
// }

// https://firebase.google.com/docs/functions/typescript

// TODO: use displayName from the user object not this profile in the DB

// export const newUser = functions.auth // .region("europe-west1")
//     .user()
//     .onCreate((user) => {
//       admin.database().ref("users").child(user.uid).set({
//         display_name: user.displayName?.toLowerCase(),
//       });
//       functions.logger.info("New user created", {structuredData: true});
//       functions.logger.info(user); // log the user object
//       return null;
//     });

export const removeUser = functions.auth // .region("europe-west1")
    .user()
    .onDelete(async (user) => {
      firestore().collection("users").doc(user.uid).delete();
      const docs = await firestore()
          .collectionGroup("reviews")
          .where("user", "==", user.uid)
          .get();
      docs.forEach((element) => {
        element.ref.delete();
      });
      functions.logger.info("User deleted", {structuredData: true});
      functions.logger.info(user); // log the user object
      return null;
    });


//
// When a review is created,
//    update its ACL
//
export const addReview = functions.firestore
    .document("movies/{showId}/reviews/{authorId}")
    .onCreate(async (snap, context) => {
      const review = snap.data();
      updateReviewAcl(review.user, context.params.showId);
    });


//
// When a friend is added or deleted,
//    update all reviews ACLs
//
export const updateFriends = functions.firestore
    .document("users/{userId}/friends/{friendId}")
    .onWrite(async (snap, context) => {
      await updateAllReviewsAcl(context.params.userId);
      functions.logger.info("Friend added so all reviews updated", {
        structuredData: true,
      });
      functions.logger.info(context.params.userId);
      return null;
    });
