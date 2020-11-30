import Foundation
import ComposableArchitecture

struct EntryComposeEnviornment {
    var mainQueue: AnySchedulerOf<DispatchQueue>

    let client: Client
    let secretsStore: SecretsStore
    let configStore: BlogConfigurationStore
}
