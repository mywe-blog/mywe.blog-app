import Foundation
import KeychainAccess

struct BlogConfiguration: Codable, Equatable, Identifiable {
    var id = UUID()

    var serviceIdentifier: String
    var urlString: String
}
