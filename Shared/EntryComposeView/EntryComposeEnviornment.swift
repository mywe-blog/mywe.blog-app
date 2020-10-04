import Foundation
import ComposableArchitecture

struct EntryComposeEnviornment {
    var mainQueue: AnySchedulerOf<DispatchQueue>

    let service: MyWeBlogService
    let secretsStore: SecretsStore
}
