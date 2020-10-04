import Foundation
import KeychainAccess

struct SecretsStore {
    struct Keys {
        static let repoName = "repoName"
        static let accessToken = "accessToken"
    }

    private let keychain: Keychain

    init(
        keychain: Keychain = Keychain(service: "blog.mywe.secrets")
    ) {
        self.keychain = keychain
    }

    var repoName: String? {
        get {
            keychain[string: Keys.repoName]
        }
        set {
            keychain[string: Keys.repoName] = newValue
        }
    }

    var accessToken: String? {
        get {
            keychain[string: Keys.accessToken]
        }
        set {
            keychain[string: Keys.accessToken] = newValue
        }
    }
}
