// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();

exports.sendEventWriteNotification = functions.firestore
    .document('room/{roomId}/event/{eventId}')
    .onWrite(async (change, context) => {
        const roomUid = context.params.roomId;
        const eventUid = context.params.eventId;

        const event = change.after.data();
        if (!event) {
            return console.log('Room', roomUid, 'removed', eventUid);
        }
        console.log('Room:', roomUid, 'has new or updated event:', eventUid);
        console.log('event:', event);

        if (!event.responderList.length) {
            return console.log('No responders added to event.');
        }

        const tokens = getTokens(event.responderList.filter(
            responder => responder.uid !== event.authorId));

        console.log('device tokens to send to:', tokens);

        if (!tokens || !tokens.length) {
            return console.log('No recipients found');
        }

        let authorName;
        try {
            authorName = await db.collection('user').doc(event.authorId)
                .get().then(user => user.data().name);
        } catch (exception) {
            console.log(`Author ${event.authorId} not present in DB:`, exception);
        }

        const payload = {
            notification: {
                title: 'New awesome event for ya!',
                body: `Let ${authorName ? authorName : 'author'} know if you'll be participating in ${event.name}!`,
                click_action: 'FLUTTER_NOTIFICATION_CLICK'
            }
        };
        return admin.messaging().sendToDevice(tokens, payload);
    });

exports.sendMinAcceptedReachedNotification = functions.firestore
    .document('room/{roomId}/event/{eventId}')
    .onWrite(async (change, context) => {
        const question = change.after.data();
        if (!question) {
            return console.log('Room', roomUid, 'removed', eventUid);
        }

        if (!question.minAccepted ||
            question.minAccepted <= 0 ||
            question.responderList.length < question.minAccepted) {
            return;
        }

        const tokens = getTokens(question.responderList);

        if (!tokens || !tokens.length) {
            return console.log('No recipients found');
        }

        const payload = {
            notification: {
                title: 'Your crew is ready!',
                body: `There are enough participants for ${event.name}.`,
                click_action: 'FLUTTER_NOTIFICATION_CLICK'
            }
        };
        return admin.messaging().sendToDevice(tokens, payload);
    });

function getTokens(userList) {
    let tokens = await Promise.all(userList.map(async responder => {
        try {
            return await db.collection('user').doc(responder.uid).get().then(user => {
                console.log('Notification recipient: ', user.data());
                return user.data().pushToken;
            });
        } catch (exception) {
            console.log(`User ${responder.name} not present in DB:`, exception);
            return null;
        }
    }));

    return tokens.filter(token => token !== null);
}