import java.util
import android.os
import android.util
import android.database

class SignInModel {
	class let TAG = "SignInModel"
	
	let observable = SignInObservable()
	var signInTask: SignInTask!
	var isWorking: Boolean = false
	
	init() {
		Log.i(TAG, "new Instance")
	}
	
	func signIn(userName: String, password: String) {
		if (isWorking) {
			return;
		}

		observable.notifyStarted(self);

		isWorking = true;
		signInTask = SignInTask(userName, password: password, context: self);
		signInTask.execute();
	}

	func stopSignIn() {
		if (isWorking) {
			signInTask.cancel(true);
			isWorking = false;
		}
	}

	func registerObserver(observer: Observer) {
		observable.registerObserver(observer);
		if (isWorking) {
			observer.onSignInStarted(self);
		}
	}

	func unregisterObserver(observer: Observer) {
		observable.unregisterObserver(observer);
	}
	
	class SignInTask: AsyncTask<Object, Object, Boolean> {
		let userName: String
		let password: String
		let context: SignInModel!
		
		init(userName: String, password: String, context: SignInModel) {
			self.userName = userName
			self.password = password
			self.context = context
		}
		
		override func doInBackground(arg1: Object...) -> Boolean! {
			let communicator = CommunicatorFactory.createBackendCommunicator()
			
			__try {
				return communicator.postSignIn(userName, password: password)
			} __catch E: InterruptedException {
				Log.i(TAG, "Sign-in interrupted.")
				return false
			}
		}
		
		override func onPostExecute(result: Boolean!) {
			context.isWorking = false;

			if (result) {
				context.observable.notifySucceeded(context);
			} else {
				context.observable.notifyFailed(context);
			}
		}
	}
	
	protocol Observer {
		func onSignInStarted(sender: SignInModel)
		func onSignInSucceeded(sender: SignInModel)
		func onSignInFailed(sender: SignInModel)
	}
	
	class SignInObservable: android.database.Observable<SignInModel.Observer> {			  
		func notifyStarted(sender: SignInModel) {
			for observer in mObservers {
				observer.onSignInStarted(sender)
			}
		}

		func notifySucceeded(sender: SignInModel) {
			for observer in mObservers {
				observer.onSignInSucceeded(sender)
			}
		}

		func notifyFailed(sender: SignInModel) {
			for observer in mObservers {
				observer.onSignInFailed(sender)
			}
		}
	}
}
