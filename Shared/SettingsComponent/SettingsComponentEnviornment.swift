import Foundation

final class SettingsComponentEnviornment {
    init(secretsStore: SecretsStore) {
        self.secretsStore = secretsStore
    }

    var secretsStore: SecretsStore
}
