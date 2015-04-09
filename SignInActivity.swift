import java.util

import android.app;
import android.content;
import android.os;
import android.util;
import android.view;
import android.widget;

class SignInActivity : Activity, SignInModel.Observer {
	class let TAG = "SignInActivity"
	class let TAG_WORKER = "TAG_WORKER"
	
	var userName: EditText!
	var password: EditText!
	var submit: View!
	var progress: View!
	
	private var signInModel: SignInModel!
	
	override func onCreate(savedInstanceState: Bundle!) {
		Log.i(TAG, "onCreate")
		super.onCreate(savedInstanceState)
		setContentView(R.layout.activity_sign_in);

		userName = findViewById(R.id.view_username) as! EditText
		password = findViewById(R.id.view_password) as! EditText
		submit = findViewById(R.id.view_submit)
		progress = findViewById(R.id.view_progress)

		submit.setOnClickListener {
			let un = self.userName.getText().toString()
			let pwd = self.password.getText().toString()
			
			self.signInModel.signIn(un, password: pwd)
		}

		let retainedWorkerFragment =
				getFragmentManager().findFragmentByTag(TAG_WORKER) as? SignInWorkerFragment

		if (retainedWorkerFragment != nil) {
			signInModel = retainedWorkerFragment!.signInModel
		} else {
			let workerFragment = SignInWorkerFragment()

			getFragmentManager().beginTransaction()
					.add(workerFragment, TAG_WORKER)
					.commit();

			signInModel = workerFragment.signInModel
		}

		signInModel.registerObserver(self)
	}
	
	override func onDestroy() {
		super.onDestroy()
		signInModel.unregisterObserver(self)

		if (isFinishing()) {
			signInModel.stopSignIn()
		}
	}
	
	func onSignInStarted(signInModel: SignInModel) {
		Log.i(TAG, "onSignInStarted")
		showProgress(true)
	}

	func onSignInSucceeded(signInModel: SignInModel) {
		Log.i(TAG, "onSignInSucceeded")
		finish()
		startActivity(Intent(self, SuccessActivity.self))
	}

	func onSignInFailed(signInModel: SignInModel) {
		Log.i(TAG, "onSignInFailed")
		showProgress(false)
		Toast.makeText(self, R.string.sign_in_error, Toast.LENGTH_SHORT).show()
	}

	func showProgress(show: Boolean) {
		userName.setEnabled(!show)
		password.setEnabled(!show)
		submit.setEnabled(!show)
		progress.setVisibility(show ? View.VISIBLE : View.GONE);
	}
}