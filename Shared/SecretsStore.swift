import Foundation
import KeychainAccess

struct SecretsStore {
    struct Keys {
        static let repoName = "repoName"
        static let accessToken = "accessToken"
        static let localPath = "localPath"
    }

    private let keychain: Keychain

    init(
        serviceIdentifier: String
    ) {
        self.keychain = Keychain(service: "blog.mywe.secrets-\(serviceIdentifier)")
    }

    var contentLocation: ContentLocation? {
        get {
            if let localPath = localPath {
                return .local(path: localPath)
            }

            if let repoName = repoName,
               let accessToken = accessToken {
                return .github(repo: repoName, accessToken: accessToken)
            }

            return nil
        }
        set {
            switch newValue {
            case .local(let path):
                self.localPath = path
                self.repoName = nil
                self.accessToken = nil
            case .github(let repo, let accessToken):
                self.repoName = repo
                self.accessToken = accessToken
                self.localPath = nil
            case .none:
                self.repoName = nil
                self.accessToken = nil
                self.localPath = nil
            }
        }
    }

    private var repoName: String? {
        get {
            keychain[string: Keys.repoName]
        }
        set {
            keychain[string: Keys.repoName] = newValue
        }
    }

    private var accessToken: String? {
        get {
            keychain[string: Keys.accessToken]
        }
        set {
            keychain[string: Keys.accessToken] = newValue
        }
    }

    private var localPath: String? {
        get {
            keychain[string: Keys.localPath]
        }
        set {
            keychain[string: Keys.localPath] = newValue
        }
    }
}
