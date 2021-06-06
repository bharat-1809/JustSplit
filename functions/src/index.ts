import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const expenseCreated = functions.firestore
  .document("users/{userId}/expenses/{expenseId}")
  .onCreate(async (snapshot) => {
    const expense = snapshot.data();

    if (expense["groupId"] === null) {
      await nonGroupWrite(
        expense,
        "New Expense Created",
        "created an expense with you",
        WriteType.Create
      );
    } else {
      await groupWrite(
        expense,
        "New Group Expense Created",
        "created an expense in a group you are in",
        WriteType.Create
      );
    }

    return Promise.all;
  });

export const expenseUpdated = functions.firestore
  .document("users/{userId}/expenses/{expenseId}")
  .onUpdate(async (change) => {
    const expense = change.after.data();

    if (expense["groupId"] === null) {
      await nonGroupWrite(
        expense,
        "Expense Updated",
        `updated ${expense["description"]} expense with you`,
        WriteType.Update
      );
    } else {
      await groupWrite(
        expense,
        "Group Expense Updated",
        `updated ${expense["description"]} expense in a group you are in`,
        WriteType.Update
      );
    }

    return Promise.all;
  });

export const expenseDeleted = functions.firestore
  .document("users/{userId}/expenses/{expenseId}")
  .onDelete(async (snapshot) => {
    const expense = snapshot.data();

    if (expense["groupId"] === null) {
      await nonGroupWrite(
        expense,
        "Expense Deleted",
        `deleted ${expense["description"]} expense with you`,
        WriteType.Delete
      );
    } else {
      await groupWrite(
        expense,
        "Group Expense Deleted",
        `deleted ${expense["description"]} expense in a group you are in`,
        WriteType.Delete
      );
    }

    return Promise.all;
  });

async function nonGroupWrite(
  expense: FirebaseFirestore.DocumentData,
  title: string,
  body: string,
  writeType: WriteType
) {
  const querySnapshotTo = await db
    .collection("users")
    .where("id", "==", expense["to"])
    .get();
  const docTo = querySnapshotTo.docs;
  const dataTo = docTo[0].data();

  const querySnapshotFrom = await db
    .collection("users")
    .where("id", "==", expense["from"])
    .get();
  const docFrom = querySnapshotFrom.docs;
  const dataFrom = docFrom[0].data();

  const toBeNotifiedUserId = dataTo["id"];
  const deviceToken = dataTo["deviceToken"];
  const writeAuthorName = dataFrom["firstName"];

  if (writeType === WriteType.Create) {
    if (toBeNotifiedUserId === expense["createdBy"]) return;
  } else if (writeType === WriteType.Update) {
    if (toBeNotifiedUserId === expense["updatedBy"]) return;

    /// In case of deleting an expense we are first updating it to store [deletedBy]
    /// so to not listen to such triggers below line is necessary
    if (expense["deletedBy"] != null) return;
  } else if (writeType === WriteType.Delete) {
    if (toBeNotifiedUserId === expense["deletedBy"]) return;
  }

  const payload: admin.messaging.MessagingPayload = {
    notification: {
      title: title,
      body: `${writeAuthorName} ${body}`,
      click_action: "FLUTTER_NOTIFICATION_CLICK",
    },
  };

  const response = await fcm.sendToDevice(deviceToken, payload);
  const results = response.results;

  const error = results[0].error;
  if (error) {
    console.error("Failure sending notification to", deviceToken, error);

    if (
      error.code === "messaging/invalid-registration-token" ||
      error.code === "messaging/registration-token-not-registered"
    ) {
      console.error(deviceToken);
    }
  }
}

async function groupWrite(
  expense: FirebaseFirestore.DocumentData,
  title: string,
  body: string,
  writeType: WriteType
) {
  const toBeNotifiedUser = expense["from"];

  let writeAuthorName;

  if (writeType === WriteType.Create) {
    if (toBeNotifiedUser === expense["createdBy"]) return;

    const querySnapshotAuthor = await db
      .collection("users")
      .where("id", "==", expense["createdBy"])
      .get();
    const docAuthor = querySnapshotAuthor.docs;
    const dataAuthor = docAuthor[0].data();

    writeAuthorName = dataAuthor["firstName"];
  } else if (writeType === WriteType.Update) {
    if (toBeNotifiedUser === expense["updatedBy"]) return;

    /// In case of deleting an expense we are first updating it to store [deletedBy]
    /// so to not listen to such triggers below line is necessary
    console.log(expense["deletedBy"]);
    if (expense["deletedBy"] != null) return;

    const querySnapshotAuthor = await db
      .collection("users")
      .where("id", "==", expense["updatedBy"])
      .get();
    const docAuthor = querySnapshotAuthor.docs;
    const dataAuthor = docAuthor[0].data();

    writeAuthorName = dataAuthor["firstName"];
  } else if (writeType === WriteType.Delete) {
    if (toBeNotifiedUser === expense["deletedBy"]) return;

    const querySnapshotAuthor = await db
      .collection("users")
      .where("id", "==", expense["deletedBy"])
      .get();
    const docAuthor = querySnapshotAuthor.docs;
    const dataAuthor = docAuthor[0].data();

    writeAuthorName = dataAuthor["firstName"];
  }

  const querySnapshotFrom = await db
    .collection("users")
    .where("id", "==", toBeNotifiedUser)
    .get();
  const docFrom = querySnapshotFrom.docs;
  const dataFrom = docFrom[0].data();

  const deviceToken = dataFrom["deviceToken"];

  const payload: admin.messaging.MessagingPayload = {
    notification: {
      title: title,
      body: `${writeAuthorName} ${body}`,
      click_action: "FLUTTER_NOTIFICATION_CLICK",
    },
  };

  const response = await fcm.sendToDevice(deviceToken, payload);
  const results = response.results;

  const error = results[0].error;
  if (error) {
    console.error("Failure sending notification to", deviceToken, error);

    if (
      error.code === "messaging/invalid-registration-token" ||
      error.code === "messaging/registration-token-not-registered"
    ) {
      console.error(deviceToken);
    }
  }
}

enum WriteType {
  Create,
  Update,
  Delete,
}
