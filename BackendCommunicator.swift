import java.util

protocol BackendCommunicator {
	func postSignIn(userName: String, password: String) -> Boolean
}

class BackendCommunicatorStub: BackendCommunicator {
	class let VALID_USERNAME = "user1"
	class let VALID_PASSWORD = "qwerty"
	
	func postSignIn(userName: String, password: String) -> Bool {
		Thread.sleep(8000)
		return userName == VALID_USERNAME && password == VALID_PASSWORD
	}
}

class CommunicatorFactory {
	class func createBackendCommunicator() -> BackendCommunicator {
		return BackendCommunicatorStub()
	}
}   