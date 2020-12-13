import Foundation

struct BlogConfigurationStore {
    private struct Keys {
        static let allConfigurations = "BlogConfigurationStore.Keys.allConfigurations"
    }

    private struct Configuration: Codable {
        let all: [BlogConfiguration]
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func store(configuration: BlogConfiguration) {
        var configurations = allConfigurations

        if let existingIndex = configurations.firstIndex(of: configuration) {
            configurations.remove(at: existingIndex)
        }

        configurations.append(configuration)

        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(Configuration(all: configurations)) {
            userDefaults.set(encoded, forKey: Keys.allConfigurations)
        }
    }

    func delete(configuration: BlogConfiguration) {
        var configurations = allConfigurations

        if let existingIndex = configurations.firstIndex(of: configuration) {
            configurations.remove(at: existingIndex)
        }

        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(Configuration(all: configurations)) {
            userDefaults.set(encoded, forKey: Keys.allConfigurations)
        }
    }

    var allConfigurations: [BlogConfiguration] {
        if let object = userDefaults.object(forKey: Keys.allConfigurations) as? Data {
            let decoder = JSONDecoder()
            if let configuration = try? decoder.decode(Configuration.self, from: object) {
                print(configuration.all)
                return configuration.all
            }
        }

        return []
    }
}
