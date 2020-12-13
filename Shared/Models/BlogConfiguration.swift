import Foundation
import KeychainAccess

struct BlogConfiguration: Codable, Equatable, Identifiable {
    init(serviceIdentifier: String, urlString: String) {
        self.id = UUID()
        self.serviceIdentifier = serviceIdentifier
        self.urlString = urlString
    }

    let id: UUID

    var serviceIdentifier: String
    var urlString: String



    static func ==(lhs: BlogConfiguration, rhs: BlogConfiguration) -> Bool {
        return lhs.id == rhs.id
    }
}
