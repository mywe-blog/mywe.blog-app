import Foundation
import KeychainAccess

struct BlogConfiguration: Codable, Equatable, Identifiable {
    var id = UUID()

    let serviceIdentifier: String
    let urlString: String
}
