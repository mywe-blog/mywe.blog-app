import Foundation
import ComposableArchitecture

struct BlogSelectorEnviornment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    let client: Client
    let secretsStore: SecretsStore
    let configStore: BlogConfigurationStore
}
