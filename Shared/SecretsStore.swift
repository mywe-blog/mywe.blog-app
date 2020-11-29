import Foundation
import KeychainAccess

struct SecretsStore {
    struct Keys {
        static let repoName = "repoName"
        static let accessToken = "accessToken"
        static let localPath = "localPath"
    }

    func contentLocation(for serviceIdentifier: String) -> ContentLocation? {
        let keychain = Keychain(service: "blog.mywe.secrets-\(serviceIdentifier)")

        if let path = keychain[string: Keys.localPath] {
            return .local(path: path)
        }

        if let repoName = keychain[string: Keys.repoName],
           let accessToken = keychain[string: Keys.accessToken] {
            return .github(repo: repoName, accessToken: accessToken)
        }

        return nil
    }

    func setContentLocation(_ contentLocation: ContentLocation?,
                            for serviceIdentifier: String) {
        let keychain = Keychain(service: "blog.mywe.secrets-\(serviceIdentifier)")

        switch contentLocation {
        case .local(let path):
            keychain[string: Keys.localPath] = path
            keychain[string: Keys.repoName] = nil
            keychain[string: Keys.accessToken] = nil
        case .github(let repo, let accessToken):
            keychain[string: Keys.repoName] = repo
            keychain[string: Keys.accessToken] = accessToken
            keychain[string: Keys.localPath] = nil
        case .none:
            keychain[string: Keys.repoName] = nil
            keychain[string: Keys.accessToken] = nil
            keychain[string: Keys.localPath] = nil
        }
    }

    func settingsComponentState(from config: BlogConfiguration) -> SettingsComponentState {
        switch contentLocation(for: config.serviceIdentifier) {
        case .github(let repo, let token):
            return SettingsComponentState(
                blogConfig: config,
                locationIndex: SettingsComponentState.Location.allCases.firstIndex(of: .github) ?? 0,
                accessToken: token,
                repoName: repo
            )
        case .local(let path):
            return SettingsComponentState(
                blogConfig: config,
                locationIndex: SettingsComponentState.Location.allCases.firstIndex(of: .local) ?? 0,
                localPath: path,
                accessToken: "",
                repoName: ""
            )
        case .none:
            return SettingsComponentState(
                blogConfig: config,
                accessToken: "",
                repoName: ""
            )
        }


    }
}
