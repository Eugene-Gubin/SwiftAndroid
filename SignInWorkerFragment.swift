import java.util
import android.app
import android.os

class SignInWorkerFragment : Fragment {
	let signInModel = SignInModel()
	
	override func onCreate(savedInstanceState: Bundle!) {
		super.onCreate(savedInstanceState)
		setRetainInstance(true)
	}
}

