const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//

exports.sendCommentNotification = functions.database.ref(`/comments/{cid}`).onWrite(event => {

	const delta = event.data.val();
  	const postId = delta.postId;
  	const commentingUserId = delta.uid;
  	
  	const getPostUserIdPromise = admin.database().ref(`/posts/${postId}`).once('value');
  
  	return Promise.all([getPostUserIdPromise]).then(results=> {
  		const postUserSnapshot = results[0];
  		const postData = postUserSnapshot.val()
  		const postUserId = postData.uid;
  		
  		const getPostUserPromise = admin.database().ref(`/users/${postUserId}`).once('value');
  		const getCommentingUserPromise = admin.database().ref(`/users/${commentingUserId}`).once('value');
  		
  		return Promise.all([getPostUserPromise, getCommentingUserPromise]).then(results => {
  			const posterSnapshot = results[0];
  			const commenterSnapshot = results[1];
  		
  			const poster = posterSnapshot.val();
  			const commenter = commenterSnapshot.val();

  			// Notification details.
	    	const payload = {
	      		notification: {
	        		title: `${commenter.username} commented.`,
	        		body: `"${delta.comment}"`,
	        		icon: poster.profileImageUrl
	      		},
	      		data: {
	      			"lat": `${postData.lat}`,
	      			"lon": `${postData.lon}`,
	      			"caption": `${postData.caption}`,
	      			"isAnon": `${postData.isAnonymous}`,
	      			"date": `${postData.createdDate}`,
	      			"commentCount": `${postData.commentCount}`,
	      			"postImageUrl": `${postData.postImageUrl}`,
	      			"postId": `${postData.postId}`,
	      			"uid": `${postData.uid}` 
	      		}
	    	};

	    	return admin.messaging().sendToDevice(poster.notificationToken, payload).then(response => {
      		
      		// For each message check if there was an error.
      		const tokensToRemove = [];
      		response.results.forEach((result, index) => {
        		const error = result.error;
        		if (error) {
          			console.error('Failure sending notification to', postUser.notificationToken, error);
          
          			// Cleanup the tokens who are not registered anymore.
          			if (error.code === 'messaging/invalid-registration-token' ||
              			error.code === 'messaging/registration-token-not-registered') {
            			tokensToRemove.push(postUser.notificationToken);
          			}
        		}
      		});
      		return Promise.all(tokensToRemove);
    	});
  	});
  	});
});